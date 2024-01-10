Return-Path: <live-patching+bounces-134-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C534482A117
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 20:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDC421C21E86
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 19:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56E222063;
	Wed, 10 Jan 2024 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ti29hYTM"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6584EB23
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 19:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cd1a1c5addso53009371fa.1
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 11:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704915459; x=1705520259; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mJU7Pk/Pll8nD+i6L8RmNZ0LVcNUXVn/4QrLY2OcnYI=;
        b=Ti29hYTM9dgDcZENDgn2QdZI1mhycPNSLiMYGQJ7tToSThn8kmQVzexQJ3Od816XcT
         1qxMZA3as1V+wI5jlQhUxqjyLUUEKLTdHt69f7kKI7oXWEVe4O8eVrfU5j8PEDjdx9+T
         Q0YoMw6Frdl8fawjcK2FYpXCvGEVUoQoz2jC4MC78LlPVTLAUX1A3oDZc42v3eFR3KPQ
         zQfQFzILFnuGS1tWEhQiSk+0XohGdTwvE+wGVhpT85e6SH7so9p92Vctjt+41QqAUvzP
         /ZaWv24jcvvXcgro8bAXAlx6DeKhtnt+uki6CxCT94U/CNtY+enqG6pnqXyTZLB3cDwv
         3vSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704915459; x=1705520259;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJU7Pk/Pll8nD+i6L8RmNZ0LVcNUXVn/4QrLY2OcnYI=;
        b=dBEgofcF+rb2FTu4l1504qYBDBS3z0rWYotwEPgGj/g1GOCaTmku3vw1IkZkY4g4Uu
         ohPkaBKj55d3G8KYs1OURo34O0LpanL1uMGByAI2f5ujQ9YkenJe+aNXyQhfEgUTRPKl
         nImX8zsVoCX30HuMAPxEZAZPVkRsXsqk/HDT+KE3J7Rgj8b6A5QNJvYAbX4FJaZMw5SM
         YBX+hhkkd1CzX5EX0QKyBVu31wW/oRGzzwJfLkJMkaBuvcNNzZNzogR57z5a7K/pVkkx
         AfzsDw9RlFvJj0GrxBuMQu5by8J9AloeO9atgft0u5AaJJ1qDsWlHS2drknSDq+GoJ8J
         OyQQ==
X-Gm-Message-State: AOJu0YyU88LWhyeFIOxRWf9jBIm0+Vv1a3YMKSmw4qul7nU5gidtml4L
	HPlvIxW9yRh3NDrqPoSI1SaaKh6QWggTlQ==
X-Google-Smtp-Source: AGHT+IHATC4b6aZQTpT9ZdtpdvRGMH/BG4ohXqdp9Phq+vK7L0N5ppRDgeZeOPt5wLdXIyYX6rmmzA==
X-Received: by 2002:a2e:9303:0:b0:2cc:ea64:73e3 with SMTP id e3-20020a2e9303000000b002ccea6473e3mr28491ljh.41.1704915459383;
        Wed, 10 Jan 2024 11:37:39 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id o7-20020a1709026b0700b001d0c151d325sm4001666plk.209.2024.01.10.11.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 11:37:38 -0800 (PST)
Message-ID: <456e5e031d7bad9a21e2f24151341c7c45615a3a.camel@suse.com>
Subject: Re: [PATCH v1 3/5] kbuild/modpost: integrate klp-convert
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Lukas Hruska <lhruska@suse.cz>, Petr Mladek <pmladek@suse.com>, Miroslav
	Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, Josh Poimboeuf
	 <jpoimboe@redhat.com>
Date: Wed, 10 Jan 2024 16:37:34 -0300
In-Reply-To: <20231106162513.17556-4-lhruska@suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
	 <20231106162513.17556-4-lhruska@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2023-11-06 at 17:25 +0100, Lukas Hruska wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
>=20
> Update the modpost program so that it does not warn about unresolved
> symbols matching the expected format which will be then resolved by
> klp-convert.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

(The patch currently conflicts with Linus tree on Makefile and
modpost.c, but nothing to worry, AFAICS)

> ---
> =C2=A0.gitignore=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 ++++++----
> =C2=A0scripts/Makefile.modfinal | 15 +++++++++++++++
> =C2=A0scripts/Makefile.modpost=C2=A0 |=C2=A0 5 +++++
> =C2=A0scripts/mod/modpost.c=C2=A0=C2=A0=C2=A0=C2=A0 | 36 ++++++++++++++++=
++++++++++++++++++--
> =C2=A0scripts/mod/modpost.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +++
> =C2=A06 files changed, 64 insertions(+), 6 deletions(-)
>=20
> diff --git a/.gitignore b/.gitignore
> index 9fd4c9533b3d..628caf76b617 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -69,6 +69,7 @@ modules.order
> =C2=A0/Module.markers
> =C2=A0/modules.builtin
> =C2=A0/modules.builtin.modinfo
> +/modules.livepatch
> =C2=A0/modules.nsdeps
> =C2=A0
> =C2=A0#
> diff --git a/Makefile b/Makefile
> index 2fdd8b40b7e0..459b9c9fe0a8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1185,6 +1185,7 @@ PHONY +=3D prepare0
> =C2=A0export extmod_prefix =3D $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
> =C2=A0export MODORDER :=3D $(extmod_prefix)modules.order
> =C2=A0export MODULES_NSDEPS :=3D $(extmod_prefix)modules.nsdeps
> +export MODULES_LIVEPATCH :=3D $(extmod-prefix)modules.livepatch
> =C2=A0
> =C2=A0ifeq ($(KBUILD_EXTMOD),)
> =C2=A0
> @@ -1535,8 +1536,8 @@ endif
> =C2=A0#
> =C2=A0
> =C2=A0# *.ko are usually independent of vmlinux, but
> CONFIG_DEBUG_INFO_BTF_MODULES
> -# is an exception.
> -ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +# and CONFIG_LIVEPATCH are exceptions.
> +ifneq ($(or $(CONFIG_DEBUG_INFO_BTF_MODULES),$(CONFIG_LIVEPATCH)),)
> =C2=A0KBUILD_BUILTIN :=3D 1
> =C2=A0modules: vmlinux
> =C2=A0endif
> @@ -1595,8 +1596,9 @@ endif
> =C2=A0# Directories & files removed with 'make clean'
> =C2=A0CLEAN_FILES +=3D include/ksym vmlinux.symvers modules-only.symvers =
\
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 modules.builtin modules.built=
in.modinfo
> modules.nsdeps \
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 compile_commands.json .thinlto-cac=
he rust/test
> rust/doc \
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rust-project.json .vmlinux.objs .v=
mlinux.export.c
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 modules.livepatch compile_commands=
.json .thinlto-
> cache \
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rust/test rust/doc rust-project.js=
on .vmlinux.objs \
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .vmlinux.export.c
> =C2=A0
> =C2=A0# Directories & files removed with 'make mrproper'
> =C2=A0MRPROPER_FILES +=3D include/config include/generated=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index fc19f67039bd..155d07476a2c 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -14,6 +14,7 @@ include $(srctree)/scripts/Makefile.lib
> =C2=A0
> =C2=A0# find all modules listed in modules.order
> =C2=A0modules :=3D $(call read-file, $(MODORDER))
> +modules-klp :=3D $(call read-file, $(MODULES_LIVEPATCH))
> =C2=A0
> =C2=A0__modfinal: $(modules:%.o=3D%.ko)
> =C2=A0	@:
> @@ -65,6 +66,20 @@ endif
> =C2=A0
> =C2=A0targets +=3D $(modules:%.o=3D%.ko) $(modules:%.o=3D%.mod.o)
> =C2=A0
> +# Livepatch
> +# ------------------------------------------------------------------
> ---------
> +
> +%.tmp.ko: %.o %.mod.o FORCE
> +	+$(call if_changed,ld_ko_o)
> +
> +quiet_cmd_klp_convert =3D KLP=C2=A0=C2=A0=C2=A0=C2=A0 $@
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd_klp_convert =3D scripts/livepatch/klp=
-convert $< $@
> +
> +$(modules-klp:%.o=3D%.ko): %.ko: %.tmp.ko FORCE
> +	$(call if_changed,klp_convert)
> +
> +targets +=3D $(modules-klp:.ko=3D.tmp.ko)
> +
> =C2=A0# Add FORCE to the prequisites of a target to force it to be always
> rebuilt.
> =C2=A0# -----------------------------------------------------------------=
-
> ---------
> =C2=A0
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 39472e834b63..c757f5eddc3e 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -47,6 +47,7 @@ modpost-args
> =3D										\
> =C2=A0	$(if $(KBUILD_MODPOST_WARN),-
> w)							\
> =C2=A0	$(if $(KBUILD_NSDEPS),-d
> $(MODULES_NSDEPS))					\
> =C2=A0	$(if
> $(CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS)$(KBUILD_NSDEPS),-
> N)	\
> +	$(if $(CONFIG_LIVEPATCH),-l
> $(MODULES_LIVEPATCH))				\
> =C2=A0	$(if $(findstring 1, $(KBUILD_EXTRA_WARN)),-
> W)					\
> =C2=A0	-o $@
> =C2=A0
> @@ -144,6 +145,10 @@ $(output-symdump): $(modpost-deps) FORCE
> =C2=A0	$(call if_changed,modpost)
> =C2=A0
> =C2=A0__modpost: $(output-symdump)
> +ifndef CONFIG_LIVEPATCH
> +	$(Q)rm -f $(MODULES_LIVEPATCH)
> +	$(Q)touch $(MODULES_LIVEPATCH)
> +endif
> =C2=A0PHONY +=3D FORCE
> =C2=A0FORCE:
> =C2=A0
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index b29b29707f10..f6afa2e10601 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1733,6 +1733,10 @@ static void read_symbols(const char *modname)
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> +	/* Livepatch modules have unresolved symbols resolved by
> klp-convert */
> +	if (get_modinfo(&info, "livepatch"))
> +		mod->is_livepatch =3D true;
> +
> =C2=A0	if (extra_warn && !get_modinfo(&info, "description"))
> =C2=A0		warn("missing MODULE_DESCRIPTION() in %s\n",
> modname);
> =C2=A0	for (sym =3D info.symtab_start; sym < info.symtab_stop; sym++)
> {
> @@ -1821,10 +1825,18 @@ static void check_exports(struct module *mod)
> =C2=A0		const char *basename;
> =C2=A0		exp =3D find_symbol(s->name);
> =C2=A0		if (!exp) {
> -			if (!s->weak && nr_unresolved++ <
> MAX_UNRESOLVED_REPORTS)
> +			if (!s->weak && nr_unresolved++ <
> MAX_UNRESOLVED_REPORTS) {
> +				/*
> +				 * In case of livepatch module we
> allow
> +				 * unresolved symbol with a specific
> format
> +				 */
> +				if (mod->is_livepatch &&
> +				=C2=A0=C2=A0=C2=A0 strncmp(s->name, KLP_SYM_RELA,
> strlen(KLP_SYM_RELA)) =3D=3D 0)
> +					break;
> =C2=A0				modpost_log(warn_unresolved ?
> LOG_WARN : LOG_ERROR,
> =C2=A0					=C2=A0=C2=A0=C2=A0 "\"%s\" [%s.ko]
> undefined!\n",
> =C2=A0					=C2=A0=C2=A0=C2=A0 s->name, mod->name);
> +			}
> =C2=A0			continue;
> =C2=A0		}
> =C2=A0		if (exp->module =3D=3D mod) {
> @@ -2257,6 +2269,20 @@ static void write_namespace_deps_files(const
> char *fname)
> =C2=A0	free(ns_deps_buf.p);
> =C2=A0}
> =C2=A0
> +static void write_livepatch_modules(const char *fname)
> +{
> +	struct buffer buf =3D { };
> +	struct module *mod;
> +
> +	list_for_each_entry(mod, &modules, list) {
> +		if (mod->is_livepatch)
> +			buf_printf(&buf, "%s.o\n", mod->name);
> +	}
> +
> +	write_if_changed(&buf, fname);
> +	free(buf.p);
> +}
> +
> =C2=A0struct dump_list {
> =C2=A0	struct list_head list;
> =C2=A0	const char *file;
> @@ -2268,11 +2294,12 @@ int main(int argc, char **argv)
> =C2=A0	char *missing_namespace_deps =3D NULL;
> =C2=A0	char *unused_exports_white_list =3D NULL;
> =C2=A0	char *dump_write =3D NULL, *files_source =3D NULL;
> +	char *livepatch_modules =3D NULL;
> =C2=A0	int opt;
> =C2=A0	LIST_HEAD(dump_lists);
> =C2=A0	struct dump_list *dl, *dl2;
> =C2=A0
> -	while ((opt =3D getopt(argc, argv, "ei:mnT:to:au:WwENd:")) !=3D
> -1) {
> +	while ((opt =3D getopt(argc, argv, "ei:l:mnT:to:au:WwENd:"))
> !=3D -1) {
> =C2=A0		switch (opt) {
> =C2=A0		case 'e':
> =C2=A0			external_module =3D true;
> @@ -2282,6 +2309,9 @@ int main(int argc, char **argv)
> =C2=A0			dl->file =3D optarg;
> =C2=A0			list_add_tail(&dl->list, &dump_lists);
> =C2=A0			break;
> +		case 'l':
> +			livepatch_modules =3D optarg;
> +			break;
> =C2=A0		case 'm':
> =C2=A0			modversions =3D true;
> =C2=A0			break;
> @@ -2361,6 +2391,8 @@ int main(int argc, char **argv)
> =C2=A0
> =C2=A0	if (dump_write)
> =C2=A0		write_dump(dump_write);
> +	if (livepatch_modules)
> +		write_livepatch_modules(livepatch_modules);
> =C2=A0	if (sec_mismatch_count && !sec_mismatch_warn_only)
> =C2=A0		error("Section mismatches detected.\n"
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "Set CONFIG_SECTION_MISMATCH_WARN_=
ONLY=3Dy to
> allow them.\n");
> diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
> index dfdb9484e325..7cb8d604d739 100644
> --- a/scripts/mod/modpost.h
> +++ b/scripts/mod/modpost.h
> @@ -98,6 +98,8 @@ static inline void __endian(const void *src, void
> *dest, unsigned int size)
> =C2=A0
> =C2=A0#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
> =C2=A0
> +#define KLP_SYM_RELA ".klp.sym.rela."
> +
> =C2=A0void *do_nofail(void *ptr, const char *expr);
> =C2=A0
> =C2=A0struct buffer {
> @@ -119,6 +121,7 @@ struct module {
> =C2=A0	bool is_gpl_compatible;
> =C2=A0	bool from_dump;		/* true if module was loaded
> from *.symvers */
> =C2=A0	bool is_vmlinux;
> +	bool is_livepatch;
> =C2=A0	bool seen;
> =C2=A0	bool has_init;
> =C2=A0	bool has_cleanup;


