Return-Path: <live-patching+bounces-133-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C4782A0A6
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 20:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D20328AF6E
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 19:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4D74D599;
	Wed, 10 Jan 2024 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DrIxpTz3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804A84D594
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a28bf46ea11so791111066b.1
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 11:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704913418; x=1705518218; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MW6HcicYJXEMmiKPUj92QCUpCKt9gXfWakdsfMe2Co8=;
        b=DrIxpTz3JwT/BsCRQvuh+6hy4Ik32HkM32xWxAVnjWqWhPG484Oe+7Q85S3Ws31OYD
         RHXjsR/V7JrKSB1r8ZJRa8NZcOlY1amydDBGDhRPiHwUDO9unJgKoa+2wFuzZSheRpuM
         J++npLhZ/Ovj4cUjxtB6lQDQnJCYn3w+sCvK3axi+DUYtDXrQcDmujJkjMV78OMPbdti
         4HpRh+XFE5MX62mjmR5++jygUSC+8O3yejIJDVCkr2X91BHu1esKAlkp2TfXG1TtZBx0
         Ht1CbPhfyYqJ+qMnT8QyPFsgad+V6uPCBUtfLZdGVI1y+WuWM61oNl3/QLk8HwoG+wNR
         hjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704913418; x=1705518218;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MW6HcicYJXEMmiKPUj92QCUpCKt9gXfWakdsfMe2Co8=;
        b=Pd2PqIYxvZ02oO6GhCRWHDO23PUGPfqkDevVZofWiJrvxzwcQHgLB2vylWMVeSZbsf
         K2lFMCmViO/IxEWXsESwPYFcyOsbfO4JSUe13I+9ad9WjNOgDpDcLfZsIel4huJYBMFD
         wGViw1T3XQVF5rYYcYNahuYrs/j1uscCIYEPrnqSevFG1vvuZ3rY+Nj8uWyD0A2wsn0/
         0igdggUnhZ08NLayGUS21Sej+Ozw3NEXj7kv3n1oDCOViaCrUFjFKsdtZwka7PCoNY1b
         +1G9ri4hreRh2FmacW854ZR8GllxcyTVh0DVeGAVrzp3YngW1ZoSPBEzI1JRG6oj3erG
         EQ8Q==
X-Gm-Message-State: AOJu0YyN72g+cm1AFPXCfrAJOeVPGovIUCfpcRy1tTAWey04nIOjlvN1
	vO3x6M1XsLkwmmYNoZd6LDMDpjfioxr24g==
X-Google-Smtp-Source: AGHT+IH7C0oOjaNf1MRtCex6TPsLjtW/LsKYg3+etlmy5u4vTtYpCcZE0h32QPvlHn2PCmeT73ahYg==
X-Received: by 2002:a17:907:1049:b0:a2b:42a:8e6 with SMTP id oy9-20020a170907104900b00a2b042a08e6mr552610ejb.21.1704913417783;
        Wed, 10 Jan 2024 11:03:37 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id mj22-20020a17090b369600b0028be0ec6e76sm1983906pjb.28.2024.01.10.11.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 11:03:37 -0800 (PST)
Message-ID: <8c9698b7cabf76e783a0a1a6368de0c11134e659.camel@suse.com>
Subject: Re: [PATCH v1 2/5] livepatch: Add klp-convert tool
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Petr Mladek <pmladek@suse.com>, Lukas Hruska <lhruska@suse.cz>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-kbuild@vger.kernel.org, Josh Poimboeuf
 <jpoimboe@redhat.com>
Date: Wed, 10 Jan 2024 16:03:32 -0300
In-Reply-To: <ZZgEHFIbfCbSWy4N@alley>
References: <20231106162513.17556-1-lhruska@suse.cz>
	 <20231106162513.17556-3-lhruska@suse.cz> <ZZgEHFIbfCbSWy4N@alley>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-01-05 at 14:29 +0100, Petr Mladek wrote:
> On Mon 2023-11-06 17:25:10, Lukas Hruska wrote:
> > Livepatches need to access external symbols which can't be handled
> > by the normal relocation mechanism. It is needed for two types
> > of symbols:
> >=20
> > =C2=A0 + Symbols which can be local for the original livepatched
> > function.
> > =C2=A0=C2=A0=C2=A0 The alternative implementation in the livepatch sees=
 them
> > =C2=A0=C2=A0=C2=A0 as external symbols.
> >=20
> > =C2=A0 + Symbols in modules which are exported via EXPORT_SYMBOL*().
> > They
> > =C2=A0=C2=A0=C2=A0 must be handled special way otherwise the livepatch =
module
> > would
> > =C2=A0=C2=A0=C2=A0 depend on the livepatched one. Loading such livepatc=
h would
> > cause
> > =C2=A0=C2=A0=C2=A0 loading the other module as well.
> >=20
> > The address of these symbols can be found via kallsyms. Or they can
>=20
> Please, remove the extra space at the end of the line.
>=20
> > be relocated using livepatch specific relocation sections as
> > specified
> > in Documentation/livepatch/module-elf-format.txt.
> >=20
> > Currently, there is no trivial way to embed the required
> > information as
> > requested in the final livepatch elf object. klp-convert solves
> > this
> > problem by using annotations in the elf object to convert the
> > relocation
> > accordingly to the specification, enabling it to be handled by the
> > livepatch loader.
> >=20
> > Given the above, create scripts/livepatch to hold tools developed
> > for
> > livepatches and add source files for klp-convert there.
> >=20
> > Allow to annotate such external symbols in the livepatch by a macro
> > KLP_RELOC_SYMBOL(). It will create symbol with all needed
> > metadata. For example:
> >=20
> > =C2=A0 extern char *saved_command_line \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 KLP_RELOC_SYMBOL(vmlinux, vmlinux,
> > saved_command_line, 0);
> >=20
> > would create symbol
> >=20
> > $>readelf -r -W <compiled livepatch module>:
> > Relocation section '.rela.text' at offset 0x32e60 contains 10
> > entries:
> > =C2=A0=C2=A0=C2=A0 Offset=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 Info=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Symbol's
> > Value=C2=A0 Symbol's Name + Addend
> > [...]
> > 0000000000000068=C2=A0 0000003c00000002 R_X86_64_PC32=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > 0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0
> > - 4
> > [...]
> >=20
> >=20
> > Also add scripts/livepatch/klp-convert. The tool transforms symbols
> > created by KLP_RELOC_SYMBOL() to object specific rela sections
> > and rela entries which would later be proceed when the livepatch
> > or the livepatched object is loaded.
> >=20
> > For example, klp-convert would replace the above symbols with:
>=20
> s/above symbols/above symbol/
>=20
> > $> readelf -r -W <livepatch_module_proceed_by_klp_convert>
> > Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60
> > contains 1 entry:
> > =C2=A0=C2=A0=C2=A0 Offset=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 Info=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Type=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Symbol's
> > Value=C2=A0 Symbol's Name + Addend
> > 0000000000000068=C2=A0 0000003c00000002 R_X86_64_PC32=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > 0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
> >=20
> > klp-convert relies on libelf and on a list implementation. Add
> > files
> > scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a
> > libelf
> > interfacing layer and scripts/livepatch/list.h, which is a list
> > implementation.
> >=20
> > Update Makefiles to correctly support the compilation of the new
> > tool,
> > update MAINTAINERS file and add a .gitignore file.
> >=20
> > ---
> > =C2=A0MAINTAINERS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 1 +
> > =C2=A0include/linux/livepatch.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 19 +
> > =C2=A0scripts/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> > =C2=A0scripts/livepatch/.gitignore=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> > =C2=A0scripts/livepatch/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 5 +
> > =C2=A0scripts/livepatch/elf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 817
> > ++++++++++++++++++++++++++++++++
> > =C2=A0scripts/livepatch/elf.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 73 +++
>=20
> I see a similar code in
>=20
> =C2=A0=C2=A0=C2=A0 tools/objtool/elf.c
> =C2=A0=C2=A0=C2=A0 tools/objtool/include/objtool/elf.h
>=20
> Both variants have been written by Josh. I wonder if we could share
> one implementation. Josh?
>=20
> > =C2=A0scripts/livepatch/klp-convert.c | 283 +++++++++++
> > =C2=A0scripts/livepatch/klp-convert.h |=C2=A0 42 ++
> > =C2=A0scripts/livepatch/list.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 391 +++++++++++++++
>=20
> And probably also the list.h

I understand that code that live on tools/ are usually self contained,
so I'm not sure how can this code be shared. Is it advisable to add
list.h, elf.h to tools/include/tools? I'm not sure about the elf.c
tough.

>=20
> > =C2=A010 files changed, 1633 insertions(+)
> > =C2=A0create mode 100644 scripts/livepatch/.gitignore
> > =C2=A0create mode 100644 scripts/livepatch/Makefile
> > =C2=A0create mode 100644 scripts/livepatch/elf.c
> > =C2=A0create mode 100644 scripts/livepatch/elf.h
> > =C2=A0create mode 100644 scripts/livepatch/klp-convert.c
> > =C2=A0create mode 100644 scripts/livepatch/klp-convert.h
> > =C2=A0create mode 100644 scripts/livepatch/list.h
> >=20
> > --- /dev/null
> > +++ b/scripts/livepatch/klp-convert.c
> > @@ -0,0 +1,283 @@
> [...]
> > +/* Converts rela symbol names */
> > +static bool convert_symbol(struct symbol *s)
> > +{
> > +	char lp_obj_name[MODULE_NAME_LEN];
> > +	char sym_obj_name[MODULE_NAME_LEN];
> > +	char sym_name[KSYM_NAME_LEN];
> > +	char *klp_sym_name;
> > +	unsigned long sym_pos;
> > +	int poslen;
> > +	unsigned int length;
> > +
> > +	static_assert(MODULE_NAME_LEN <=3D 56, "Update limit in the
> > below sscanf()");
>=20
> IMHO, there should be "< 56" instead of "<=3D 56". The sscanf is
> limited by %55.
>=20
> Also we should check KSYM_NAME_LEN. Similar to to check in
> klp_resolve_symbols()
>=20
> 	static_assert(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN !=3D 512,
> 		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "Update limit in the below sscanf()");
>=20
> > +
> > +	if (sscanf(s->name, KLP_SYM_RELA_PREFIX
> > "%55[^.].%55[^.].%511[^,],%lu",
> > +			lp_obj_name, sym_obj_name, sym_name,
> > &sym_pos) !=3D 4) {
> > +		WARN("Invalid format of symbol (%s)\n", s->name);
> > +		return false;
> > +	}
> > +
> > +	poslen =3D calc_digits(sym_pos);
> > +
> > +	length =3D strlen(KLP_SYM_PREFIX) + strlen(sym_obj_name)
> > +		 + strlen(sym_name) + sizeof(poslen) + 3;
> > +
> > +	klp_sym_name =3D calloc(1, length);
> > +	if (!klp_sym_name) {
> > +		WARN("Memory allocation failed (%s%s.%s,%lu)\n",
> > KLP_SYM_PREFIX,
> > +				sym_obj_name, sym_name, sym_pos);
> > +		return false;
> > +	}
> > +
> > +	if (safe_snprintf(klp_sym_name, length, KLP_SYM_PREFIX
> > "%s.%s,%lu",
> > +			=C2=A0 sym_obj_name, sym_name, sym_pos)) {
> > +
> > +		WARN("Length error (%s%s.%s,%lu)", KLP_SYM_PREFIX,
> > +				sym_obj_name, sym_name, sym_pos);
> > +		free(klp_sym_name);
> > +		return false;
> > +	}
> > +
> > +	s->name =3D klp_sym_name;
> > +	s->sec =3D NULL;
> > +	s->sym.st_name =3D -1;
> > +	s->sym.st_shndx =3D SHN_LIVEPATCH;
> > +
> > +	return true;
> > +}
> > +
> > diff --git a/scripts/livepatch/klp-convert.h
> > b/scripts/livepatch/klp-convert.h
> > new file mode 100644
> > index 000000000000..34842c50c711
> > --- /dev/null
> > +++ b/scripts/livepatch/klp-convert.h
> > @@ -0,0 +1,42 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
> > + * Copyright (C) 2017 Joao Moreira=C2=A0=C2=A0 <jmoreira@suse.de>
> > + *
> > + */
> > +
> > +#define SHN_LIVEPATCH		0xff20
> > +#define SHF_RELA_LIVEPATCH	0x00100000
> > +#define MODULE_NAME_LEN		(64 - sizeof(GElf_Addr))
> > +#define WARN(format, ...) \
> > +	fprintf(stderr, "klp-convert: " format "\n",
> > ##__VA_ARGS__)
> > +
> > +struct sympos {
> > +	char *symbol_name;
> > +	char *object_name;
> > +	char *loading_obj_name;
> > +	int pos;
> > +};
>=20
> It seems that this structure is not longer used.
>=20
> > +/*
> > + * klp-convert uses macros and structures defined in the linux
> > sources
> > + * package (see include/uapi/linux/livepatch.h). To prevent the
> > + * dependency when building locally, they are defined below. Also
> > notice
> > + * that these should match the definitions from the targeted
> > kernel.
> > + */
> > +
> > +#define KLP_RELA_PREFIX			".klp.rela."
> > +#define KLP_SYM_RELA_PREFIX		".klp.sym.rela."
> > +#define KLP_SYM_PREFIX			".klp.sym."
> > +
> > +#ifndef __packed
> > +#define __packed=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __attribute=
__((packed))
> > +#endif
> > +
> > +struct klp_module_reloc {
> > +	union {
> > +		void *sym;
> > +		uint64_t sym64;	/* Force 64-bit width */
> > +	};
> > +	uint32_t sympos;
> > +} __packed;
>=20
> And this one as well.
>=20
> I do not see any other obvious problem. And it seems to work
> at least for the later added sample module.

I agree with Petr in all his other comments. With the comments
addressed, you can add:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

>=20
> Best Regards,
> Petr


