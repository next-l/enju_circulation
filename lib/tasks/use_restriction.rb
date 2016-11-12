def update_use_restriction
  YAML.load(open('db/fixtures/enju_circulation/use_restrictions.yml').read).each do |line|
    l = line[1].select! { |k, _v| %w(name display_name).include?(k) }
    UseRestriction.where(name: l['name']).first.try(:update_attributes!, l)
  end
end
