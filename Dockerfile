# Dockerfile

FROM phusion/passenger-ruby22
# MAINTAINER Ross Fairbanks "ross.fairbanks@gmail.com"

# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV=production \
    DB_USER="youuser" \
    DB_PASS="yourpass" \
    DB_HOST="localhost" \
    DB_BASE="yourbase"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Expose Nginx HTTP service
EXPOSE 80

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf

# Install requeriments 
#RUN add-apt-repository ppa:upubuntu-com/office -y
RUN apt-get update && apt-get install wget
RUN wget sourceforge.net/projects/openofficeorg.mirror/files/4.1.1/binaries/en-GB/Apache_OpenOffice_4.1.1_Linux_x86-64_install-deb_en-GB.tar.gz
RUN tar -xzvf Apache_OpenOffice_4.1.1_Linux_x86-64_install-deb_en-GB.tar.gz -C /tmp
RUN cd /tmp/en-GB/DEBS && dpkg -i *.deb 
RUN apt-get install postgresql postgresql-contrib libmagickwand-dev imagemagick openoffice -y

# Install bundle of gems
WORKDIR /home/app/webapp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Add the Rails app
ADD . /home/app/webapp
RUN chown -R app:app /home/app/webapp

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
