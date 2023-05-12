FROM ruby:2.7.5

ADD . /src
WORKDIR /src

RUN bundle install

EXPOSE 4567

CMD ["/bin/bash"]
