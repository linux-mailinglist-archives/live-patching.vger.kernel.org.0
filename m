Return-Path: <live-patching+bounces-113-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05371825471
	for <lists+live-patching@lfdr.de>; Fri,  5 Jan 2024 14:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBA3D1C21212
	for <lists+live-patching@lfdr.de>; Fri,  5 Jan 2024 13:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7F92D62C;
	Fri,  5 Jan 2024 13:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y+t3z5BE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D012D62A
	for <live-patching@vger.kernel.org>; Fri,  5 Jan 2024 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2cd1a1c5addso19215181fa.1
        for <live-patching@vger.kernel.org>; Fri, 05 Jan 2024 05:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704461342; x=1705066142; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASWjxY9bYtd6yliDsY5d/0hRbPDLTJ1ay0QqVhdDXiQ=;
        b=Y+t3z5BEantJQJNDgbWipMM1ZSxq4BGzpsmUYeIIlnuzSbIae/KqSZ5dO0YZkxq0JK
         tstCj5ZfCb8FP9SvUMXDTHEp+P34/vQR2tYB3E43eubskGrM8+K+tvD8hP+tx7dzmNo3
         YypRnSo9zIykP4p4UJ5oRWW2JsijzTbHp1akA+8OkpubpkrF5b8bnbbw8alGgagNbL/Y
         vuJJ+puDe14WQOQEAQy9QNGeWGHxKZi2o5ZJqjsoqF84uDZESv/6S3R/mGUewgnRhYVf
         3ep1muj1BkPRYEBhxmHKFK2WOuWB7mtEgukT4/iQqxaEnQtKx6wL5wUi6JHR/D5N7aHG
         0gSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704461342; x=1705066142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASWjxY9bYtd6yliDsY5d/0hRbPDLTJ1ay0QqVhdDXiQ=;
        b=viIjb0+74g9qjedQ8+vJbdOhYY5P6xVbXZA9VAkmc2a57bcfLWsTHPTzVuRER4HgNV
         LpClRcrxFcqVshUN9jBawejpL80tpP5LphKBZ/vurmHObD9ICFcg0tBuPg/UYh6A8pYS
         1A7M0tjtC7ZqBrXUbr6duP3VpYhxA4f/cjIEB3reNc4U2HwBVeRRw95VmBG1KSWDQXPX
         0KfGwnFfCr+m3BFMxA9oZ9u/SVieCUl79PfkUIiURYd2f97go0ozM7u5Lnq2Rg7cBsUl
         xXwfdXQjc4lJfQZMf3s4UC++zoG/GH5DSwgpFHzPkxc8/JAlTJ6dpKIBVpQh+kEEtWTm
         vwEQ==
X-Gm-Message-State: AOJu0YwlCXVANLdgMsno8nAeqbL0+oFSNzf9tsZASUbw9y9rrlpLvxyt
	H0SqiEhboWOknBoTHlmsBHfrehhDYKGJYQ==
X-Google-Smtp-Source: AGHT+IHc5l6upSwV5sbrVEe3KVi6IBAXvXZ3/tYg+DD3V9wzguKuMa5CHp8wkjWkZ/MX/Eo/kg1c3g==
X-Received: by 2002:a2e:99cd:0:b0:2cc:e379:88b6 with SMTP id l13-20020a2e99cd000000b002cce37988b6mr1112771ljj.27.1704461342534;
        Fri, 05 Jan 2024 05:29:02 -0800 (PST)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id o13-20020aa7d3cd000000b0055507ee70a4sm966984edr.23.2024.01.05.05.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 05:29:02 -0800 (PST)
Date: Fri, 5 Jan 2024 14:29:00 +0100
From: Petr Mladek <pmladek@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v1 2/5] livepatch: Add klp-convert tool
Message-ID: <ZZgEHFIbfCbSWy4N@alley>
References: <20231106162513.17556-1-lhruska@suse.cz>
 <20231106162513.17556-3-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106162513.17556-3-lhruska@suse.cz>

On Mon 2023-11-06 17:25:10, Lukas Hruska wrote:
> Livepatches need to access external symbols which can't be handled
> by the normal relocation mechanism. It is needed for two types
> of symbols:
> 
>   + Symbols which can be local for the original livepatched function.
>     The alternative implementation in the livepatch sees them
>     as external symbols.
> 
>   + Symbols in modules which are exported via EXPORT_SYMBOL*(). They
>     must be handled special way otherwise the livepatch module would
>     depend on the livepatched one. Loading such livepatch would cause
>     loading the other module as well.
> 
> The address of these symbols can be found via kallsyms. Or they can 

Please, remove the extra space at the end of the line.

> be relocated using livepatch specific relocation sections as specified
> in Documentation/livepatch/module-elf-format.txt.
> 
> Currently, there is no trivial way to embed the required information as
> requested in the final livepatch elf object. klp-convert solves this
> problem by using annotations in the elf object to convert the relocation
> accordingly to the specification, enabling it to be handled by the
> livepatch loader.
> 
> Given the above, create scripts/livepatch to hold tools developed for
> livepatches and add source files for klp-convert there.
> 
> Allow to annotate such external symbols in the livepatch by a macro
> KLP_RELOC_SYMBOL(). It will create symbol with all needed
> metadata. For example:
> 
>   extern char *saved_command_line \
>                  KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);
> 
> would create symbol
> 
> $>readelf -r -W <compiled livepatch module>:
> Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> [...]
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4
> [...]
> 
> 
> Also add scripts/livepatch/klp-convert. The tool transforms symbols
> created by KLP_RELOC_SYMBOL() to object specific rela sections
> and rela entries which would later be proceed when the livepatch
> or the livepatched object is loaded.
> 
> For example, klp-convert would replace the above symbols with:

s/above symbols/above symbol/

> $> readelf -r -W <livepatch_module_proceed_by_klp_convert>
> Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
> 
> klp-convert relies on libelf and on a list implementation. Add files
> scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
> interfacing layer and scripts/livepatch/list.h, which is a list
> implementation.
> 
> Update Makefiles to correctly support the compilation of the new tool,
> update MAINTAINERS file and add a .gitignore file.
>
> ---
>  MAINTAINERS                     |   1 +
>  include/linux/livepatch.h       |  19 +
>  scripts/Makefile                |   1 +
>  scripts/livepatch/.gitignore    |   1 +
>  scripts/livepatch/Makefile      |   5 +
>  scripts/livepatch/elf.c         | 817 ++++++++++++++++++++++++++++++++
>  scripts/livepatch/elf.h         |  73 +++

I see a similar code in

    tools/objtool/elf.c
    tools/objtool/include/objtool/elf.h

Both variants have been written by Josh. I wonder if we could share
one implementation. Josh?

>  scripts/livepatch/klp-convert.c | 283 +++++++++++
>  scripts/livepatch/klp-convert.h |  42 ++
>  scripts/livepatch/list.h        | 391 +++++++++++++++

And probably also the list.h

>  10 files changed, 1633 insertions(+)
>  create mode 100644 scripts/livepatch/.gitignore
>  create mode 100644 scripts/livepatch/Makefile
>  create mode 100644 scripts/livepatch/elf.c
>  create mode 100644 scripts/livepatch/elf.h
>  create mode 100644 scripts/livepatch/klp-convert.c
>  create mode 100644 scripts/livepatch/klp-convert.h
>  create mode 100644 scripts/livepatch/list.h
> 
> --- /dev/null
> +++ b/scripts/livepatch/klp-convert.c
> @@ -0,0 +1,283 @@
[...]
> +/* Converts rela symbol names */
> +static bool convert_symbol(struct symbol *s)
> +{
> +	char lp_obj_name[MODULE_NAME_LEN];
> +	char sym_obj_name[MODULE_NAME_LEN];
> +	char sym_name[KSYM_NAME_LEN];
> +	char *klp_sym_name;
> +	unsigned long sym_pos;
> +	int poslen;
> +	unsigned int length;
> +
> +	static_assert(MODULE_NAME_LEN <= 56, "Update limit in the below sscanf()");

IMHO, there should be "< 56" instead of "<= 56". The sscanf is limited by %55.

Also we should check KSYM_NAME_LEN. Similar to to check in klp_resolve_symbols()

	static_assert(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 512,
		      "Update limit in the below sscanf()");

> +
> +	if (sscanf(s->name, KLP_SYM_RELA_PREFIX "%55[^.].%55[^.].%511[^,],%lu",
> +			lp_obj_name, sym_obj_name, sym_name, &sym_pos) != 4) {
> +		WARN("Invalid format of symbol (%s)\n", s->name);
> +		return false;
> +	}
> +
> +	poslen = calc_digits(sym_pos);
> +
> +	length = strlen(KLP_SYM_PREFIX) + strlen(sym_obj_name)
> +		 + strlen(sym_name) + sizeof(poslen) + 3;
> +
> +	klp_sym_name = calloc(1, length);
> +	if (!klp_sym_name) {
> +		WARN("Memory allocation failed (%s%s.%s,%lu)\n", KLP_SYM_PREFIX,
> +				sym_obj_name, sym_name, sym_pos);
> +		return false;
> +	}
> +
> +	if (safe_snprintf(klp_sym_name, length, KLP_SYM_PREFIX "%s.%s,%lu",
> +			  sym_obj_name, sym_name, sym_pos)) {
> +
> +		WARN("Length error (%s%s.%s,%lu)", KLP_SYM_PREFIX,
> +				sym_obj_name, sym_name, sym_pos);
> +		free(klp_sym_name);
> +		return false;
> +	}
> +
> +	s->name = klp_sym_name;
> +	s->sec = NULL;
> +	s->sym.st_name = -1;
> +	s->sym.st_shndx = SHN_LIVEPATCH;
> +
> +	return true;
> +}
> +
> diff --git a/scripts/livepatch/klp-convert.h b/scripts/livepatch/klp-convert.h
> new file mode 100644
> index 000000000000..34842c50c711
> --- /dev/null
> +++ b/scripts/livepatch/klp-convert.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
> + * Copyright (C) 2017 Joao Moreira   <jmoreira@suse.de>
> + *
> + */
> +
> +#define SHN_LIVEPATCH		0xff20
> +#define SHF_RELA_LIVEPATCH	0x00100000
> +#define MODULE_NAME_LEN		(64 - sizeof(GElf_Addr))
> +#define WARN(format, ...) \
> +	fprintf(stderr, "klp-convert: " format "\n", ##__VA_ARGS__)
> +
> +struct sympos {
> +	char *symbol_name;
> +	char *object_name;
> +	char *loading_obj_name;
> +	int pos;
> +};

It seems that this structure is not longer used.

> +/*
> + * klp-convert uses macros and structures defined in the linux sources
> + * package (see include/uapi/linux/livepatch.h). To prevent the
> + * dependency when building locally, they are defined below. Also notice
> + * that these should match the definitions from the targeted kernel.
> + */
> +
> +#define KLP_RELA_PREFIX			".klp.rela."
> +#define KLP_SYM_RELA_PREFIX		".klp.sym.rela."
> +#define KLP_SYM_PREFIX			".klp.sym."
> +
> +#ifndef __packed
> +#define __packed        __attribute__((packed))
> +#endif
> +
> +struct klp_module_reloc {
> +	union {
> +		void *sym;
> +		uint64_t sym64;	/* Force 64-bit width */
> +	};
> +	uint32_t sympos;
> +} __packed;

And this one as well.

I do not see any other obvious problem. And it seems to work
at least for the later added sample module.

Best Regards,
Petr

