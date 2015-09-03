FROM trenpixster/elixir:1.0.5
MAINTAINER Julian Haeger @juliansthoughts

ADD . /code
WORKDIR /code


ENV MIX_ENV prod
RUN mix deps.get && mix compile

ENV PORT 4000
EXPOSE 4000

CMD ["mix","phoenix.server"] 
