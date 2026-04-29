# Stack-Specific Idioms — Quick Reference

Use the Project Brief in your prompt to pick the right column. Below are idioms
worth flagging when the project does NOT use them.

## .NET (ASP.NET Core)

- Validation: `[Required]`, `[Range]`, `[StringLength]`, `[RegularExpression]`, FluentValidation
- Authorization: `[Authorize]`, `[Authorize(Roles="Admin")]`, `[AllowAnonymous]` — global filters in `Program.cs` count
- Exception handling: `app.UseExceptionHandler("/error")` is the safe pattern; `app.UseDeveloperExceptionPage()` in prod is dangerous
- DTOs: project-vision often says `records-for-DTOs` (see Project Brief). Returning an `Entity` directly is a smell
- SQL: `FromSqlInterpolated` (safe) vs `FromSqlRaw` with concat (unsafe)

## NestJS / TypeScript

- Validation: `ValidationPipe` global + `class-validator` decorators (`@IsString`, `@IsInt`, `@Length`)
- Authorization: `@UseGuards(AuthGuard)`, `@Roles(Role.Admin)`, `@Public()` opt-out
- Exception handling: `HttpException` with deliberate payload; not throwing the raw error object
- DTOs: explicit DTO classes vs returning entities from service. `class-transformer` `@Expose()` / `@Exclude()`
- SQL: TypeORM `query()` with parameters vs string concat; Prisma is safe by default

## FastAPI / Python

- Validation: Pydantic models with `Field(..., min_length=, max_length=, regex=)`. Plain `dict` is the smell
- Authorization: `Depends(get_current_user)` on the route; `oauth2_scheme` requirement
- Exception handling: `HTTPException(status_code, detail)` with curated detail; not raising raw exceptions
- DTOs: `response_model=UserOut` (filtered) vs returning the ORM model directly
- SQL: SQLAlchemy `text()` with bound params vs f-string interpolation

## Spring / Java

- Validation: `@Valid @RequestBody`, `@NotNull`, `@Size`, `@Pattern`, custom validators
- Authorization: `@PreAuthorize("hasRole('ADMIN')")`, `@Secured`, method-security filter chain
- Exception handling: `@ControllerAdvice` with `@ExceptionHandler` returning curated `ResponseEntity`
- DTOs: explicit DTO classes; `@JsonIgnore` / `@JsonView` on entities; ModelMapper / MapStruct
- SQL: `JpaRepository` derived methods (safe), `@Query` with named params (safe), `EntityManager.createNativeQuery` with concat (unsafe)

## Cross-Stack: things that look safe but are not

- "Logged securely" — if the log line includes the token/password value, retention is the leak
- Try/catch that swallows then returns the message in a generic 500 — message often contains the SQL or path
- Returning `IQueryable` / `QuerySet` / `Stream` directly — exposes the whole table on iteration
- "We validate on the client" — server is the only trustable boundary
