## Branchs do Projeto

```
git checkout -b development
git push --set-upstream origin development

git checkout -b feature
git push --set-upstream origin feature

git checkout -b test
git push --set-upstream origin test

git checkout -b homologation
git push --set-upstream origin homologation

git checkout -b release
git push --set-upstream origin release
```

### Gerar TAGS para Entrega
```
git tag -a v1.0.0.0 -m "Lançamento de Versão v1.0.0.0"
git push origin v1.0.0.0
```

### Atualizar a main a partir da TAG
git checkout -b release/v1.0.0.0 v1.0.0.0
git checkout main
git merge release/v1.0.0.0