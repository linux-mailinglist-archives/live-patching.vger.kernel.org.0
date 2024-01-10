Return-Path: <live-patching+bounces-135-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A83BE82A197
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 20:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 039DFB25A18
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 19:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1914F1E1;
	Wed, 10 Jan 2024 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OKqsyv6v"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983E74F1E7
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 19:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2cd7e348311so10906511fa.2
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 11:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704916492; x=1705521292; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rpDfRf3Herj6H9nv9ttm39vJv2PeXPMa/nxjiDv/ci0=;
        b=OKqsyv6vmnQyojZa1faP9iBTHEZXch9+EqQtoz49/gaVCrtRHzfoiv9fO5ppCi7XEV
         5oUa0os+2NfLr/Ql+L4yW86hxXOBhzvG7KC6nNa2//6/3yJG71keQQuhx5Jkw3eaDjhv
         9ry6CBpysLGdt9OQExzXRpLUCuRsBuSid0RF2/3L2KelH3XrWOSf+7KorT/HqBytYSXm
         Q6MxAQxj57kOpeT3MRV6x0wc95fRbwJ4VA0OtLxbaMVO1ujR23ZEBYlryc/xo0l4M6PD
         s+mEl1e4DR9QN7oEgOzc6r/C5ziKFxyWG7ha5nRlDqPKtwBF5xr2FlupgMoQNfRQwuNj
         W8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704916492; x=1705521292;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rpDfRf3Herj6H9nv9ttm39vJv2PeXPMa/nxjiDv/ci0=;
        b=mJQ76u0cFkrlz1VZdZI3nz0XqWaae/GP/ZAnmjI3URdupyXHnTssdOQt/nGTHYxOqe
         UEuLIL4rmeiulgvILzQAPJLaANBfPTts49bTn3+sOJG4y8fhrCNhTOly6P8XFm+Cp/Pl
         mq/E6zBqpIV5Smoirt/PSYHwDgG1zJ7doEEqOFuqoaIw1PDgNumZEDU0jJ6VO/0CC7ME
         OcX1s7LB6ztgHCjq6KBvnROWLdWogoG+m7f+CZPGrSfjIhGum9AUcU+7F64i0BXUIRzs
         mEFCnZUACL3SCQL9VYGPBpqsO35qZyUHeHCZI6QoZ0HQXpbgk2DPA8xlCnY9zQ+OPZgk
         BQsQ==
X-Gm-Message-State: AOJu0YwJTgWrPV2EKSWmUlTQjQT3LGXZv3H5b3cwf8bA1k8uL9WyBngo
	bG0WkDGLBqnf11YbK4IRU20JCj7GeQcEqA==
X-Google-Smtp-Source: AGHT+IEDCughZVzw5wOMUKkSQKd4e1z2Jjt3ksK+z3TvQxPJcEhGbo2wdlnH+IgVa5aHDzORCm56JQ==
X-Received: by 2002:a2e:bc14:0:b0:2cd:7e24:321d with SMTP id b20-20020a2ebc14000000b002cd7e24321dmr64210ljf.62.1704916492671;
        Wed, 10 Jan 2024 11:54:52 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902820900b001d4cad5bcf0sm4020511pln.237.2024.01.10.11.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 11:54:52 -0800 (PST)
Message-ID: <3be436cf49b8850b95eb74ce7b7c45e05bc4ad82.camel@suse.com>
Subject: Re: [PATCH v1 5/5] documentation: Update on livepatch elf format
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Lukas Hruska <lhruska@suse.cz>, Petr Mladek <pmladek@suse.com>, Miroslav
	Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Wed, 10 Jan 2024 16:54:48 -0300
In-Reply-To: <20231106162513.17556-6-lhruska@suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
	 <20231106162513.17556-6-lhruska@suse.cz>
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
> Add a section to Documentation/livepatch/module-elf-format.rst
> describing how klp-convert works for fixing relocations.
>=20
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> ---
> =C2=A0Documentation/livepatch/module-elf-format.rst | 67
> +++++++++++++++++++
> =C2=A01 file changed, 67 insertions(+)
>=20
> diff --git a/Documentation/livepatch/module-elf-format.rst
> b/Documentation/livepatch/module-elf-format.rst
> index a03ed02ec57e..2aa9b11cd806 100644
> --- a/Documentation/livepatch/module-elf-format.rst
> +++ b/Documentation/livepatch/module-elf-format.rst
> @@ -300,3 +300,70 @@ symbol table, and relocation section indices,
> ELF information is preserved for
> =C2=A0livepatch modules and is made accessible by the module loader
> through
> =C2=A0module->klp_info, which is a :c:type:`klp_modinfo` struct. When a
> livepatch module
> =C2=A0loads, this struct is filled in by the module loader.
> +
> +6. klp-convert tool
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +The livepatch relocation sections might be created using
> +scripts/livepatch/klp-convert. It is called automatically during
> +the build as part of a module post processing.
> +
> +The tool is not able to find the symbols and all the metadata
> +automatically. Instead, all needed information must already be
> +part of rela entry for the given symbol. Such a rela can
> +be created easily by using KLP_RELOC_SYMBOL() macro after
> +the symbol declaration.
> +
> +KLP_RELOC_SYMBOL causes that the relocation entries for
> +the given symbol will be created in the following format::
> +
> +=C2=A0 .klp.sym.rela.lp_object.sym_object.sym_name,sympos
> +=C2=A0 ^=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^ ^=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^ ^=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ^ ^=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^=C2=A0=C2=A0 ^
> +=C2=A0 |___________| |_______| |________| |______|=C2=A0=C2=A0 |
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [A]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 [B]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [C]=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [D]=C2=A0=C2=A0=C2=A0 [E]
> +
> +[A]
> +=C2=A0 The symbol name is prefixed with the string ".klp.sym.rela."
> +
> +[B]
> +=C2=A0 The name of the object (i.e. "vmlinux" or name of module) which
> +=C2=A0 is livepatched.
> +
> +[C]
> +=C2=A0 The name of the object (i.e. "vmlinux" or name of module) to
> +=C2=A0 which the symbol belongs follows immediately after the prefix.
> +
> +[D]
> +=C2=A0 The actual name of the symbol.
> +
> +[E]
> +=C2=A0 The position of the symbol in the object (as according to
> kallsyms)
> +=C2=A0 This is used to differentiate duplicate symbols within the same
> +=C2=A0 object. The symbol position is expressed numerically (0, 1, 2...)=
.
> +=C2=A0 The symbol position of a unique symbol is 0.
> +
> +Example:
> +--------
> +**Livepatch source code:**
> +
> +::
> +
> +=C2=A0 extern char *saved_command_line \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 KLP_RELOC_SYMBOL(vmlinux, vmlinux,
> saved_command_line, 0);
> +
> +**`readelf -r -W` output of compiled module:**
> +
> +::
> +
> +=C2=A0 Relocation section '.rela.text' at offset 0x32e60 contains 10
> entries:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Offset=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Info=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Type=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> Symbol's Value=C2=A0 Symbol's Name + Addend
> +=C2=A0 ...
> +=C2=A0 0000000000000068=C2=A0 0000003c00000002 R_X86_64_PC32=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> 0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 -
> 4
> +=C2=A0 ...
> +
> +**`readelf -r -W` output of transformed module by klp-convert:**
> +
> +::
> +
> +=C2=A0 Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60
> contains 1 entry:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Offset=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Info=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Type=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> Symbol's Value=C2=A0 Symbol's Name + Addend
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0000000000000068=C2=A0 0000003c00000002 R=
_X86_64_PC32=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> 0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4


