FROM ruby:2.5.1

ADD Gemfile Gemfile.lock ./
ADD main.rb .

RUN bundle install

EXPOSE 4567

CMD ruby main.rb -p 4567 -o 0.0.0.0
