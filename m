Return-Path: <live-patching+bounces-126-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACEB6829B80
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 14:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E0101F2199D
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 13:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF76448CD4;
	Wed, 10 Jan 2024 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CFR5szVv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3239A495C8
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cca5d81826so55453061fa.2
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 05:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704893948; x=1705498748; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yYuHDlpeSQP0DPaCl1fybFBgm95cBWd/VxGoejBh4E8=;
        b=CFR5szVvT4GLTgQKc+/5ugj56aQnmduy7ReUJE+MNeTENyCPIlcu+yPfgmsab52axM
         5pn6F44RVAVVCNhyhEisGx/NLaRoHW2e0HS8lJwb3I++gitQNYLTmDXClQBDpBRYOw2o
         NbRJyHODRkD+7OFRerhmdgfQHsXy/tVl9c2PeHQ1d9TvWTCM1go2AhOamo05BO1mawTs
         tFDfwJrR0+6oYhWc4FgEw7wOKx9ObPaqFvVZoxqQU0K/2f9wX7lWXE57VYDLqUhlqaXC
         wbrQq7bYcFQLbMdV6tLW7PEnhPiWxqGJI6affHeGy3ql3JS6LNtebF12PleIug7P9CRm
         q0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704893948; x=1705498748;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yYuHDlpeSQP0DPaCl1fybFBgm95cBWd/VxGoejBh4E8=;
        b=vxhGeH1FgnW0IjYmNhgzSmYhvtIkiQsabLap97DTd6/IHIKFZ6pv+NWnN0KOikXR9H
         9c9INb2WgA1JmWz5jM8B5Bu3QI1qh+zU1bslGHO8vacr0UURe7UsDnuEn895KYuwX8xD
         qJhOHfI4kp6bQONRWQs5ZWPpnwGEq2CyQ4OuhQqP781Z6oI/TWUALDvigLFg51M5PC94
         G1HMstzuBMfasWhwkyfx8/3DXlhueQwQHrA/8NmhF3yrAntADcpQ3XAyr8IrKqUeUfN3
         RnfHpfb2RhKKKyhRxXJ7Ty9E7ObXhiFX5n98aasjr8JN6zVDnf86imdTUZxK6wsPXv9H
         l/VA==
X-Gm-Message-State: AOJu0YwGegmzaV1V3qeZWezX26aGUy39qyyyqEiR7mDEvSXGI7+rSR5U
	u+/R5/NqmR/VzCc9M2cPMmVOHYL8bPBdYg==
X-Google-Smtp-Source: AGHT+IFTc9I0KvBn1sBygc4Ur7jlswZ9AI9dvNPDhS34Y1In36k05J11/J0dpgN302dDT6zTczVmtA==
X-Received: by 2002:a05:651c:2059:b0:2cd:1cb7:71d5 with SMTP id t25-20020a05651c205900b002cd1cb771d5mr619348ljo.48.1704893948266;
        Wed, 10 Jan 2024 05:39:08 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id az5-20020a170902a58500b001ca86a9caccsm3613547plb.228.2024.01.10.05.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 05:39:07 -0800 (PST)
Message-ID: <96578fb7568a8c2a318c850e6979bbf8f58cc249.camel@suse.com>
Subject: Re: [PATCH v1 1/5] livepatch: Create and include UAPI headers
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Lukas Hruska <lhruska@suse.cz>, Petr Mladek <pmladek@suse.com>, Miroslav
	Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, Josh Poimboeuf
	 <jpoimboe@redhat.com>
Date: Wed, 10 Jan 2024 10:38:52 -0300
In-Reply-To: <20231106162513.17556-2-lhruska@suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
	 <20231106162513.17556-2-lhruska@suse.cz>
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
> Define klp prefixes in include/uapi/linux/livepatch.h, and use them
> for
> replacing hard-coded values in kernel/livepatch/core.c.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> ---
> =C2=A0MAINTAINERS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0include/uapi/linux/livepatch.h | 15 +++++++++++++++
> =C2=A0kernel/livepatch/core.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 5 +++--
> =C2=A03 files changed, 19 insertions(+), 2 deletions(-)
> =C2=A0create mode 100644 include/uapi/linux/livepatch.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4cc6bf79fdd8..11a2d84c1277 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12130,6 +12130,7 @@ F:	Documentation/ABI/testing/sysfs-
> kernel-livepatch
> =C2=A0F:	Documentation/livepatch/
> =C2=A0F:	arch/powerpc/include/asm/livepatch.h
> =C2=A0F:	include/linux/livepatch.h
> +F:	include/uapi/linux/livepatch.h
> =C2=A0F:	kernel/livepatch/
> =C2=A0F:	kernel/module/livepatch.c
> =C2=A0F:	lib/livepatch/
> diff --git a/include/uapi/linux/livepatch.h
> b/include/uapi/linux/livepatch.h
> new file mode 100644
> index 000000000000..e19430918a07
> --- /dev/null
> +++ b/include/uapi/linux/livepatch.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +
> +/*
> + * livepatch.h - Kernel Live Patching Core
> + *
> + * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
> + */
> +
> +#ifndef _UAPI_LIVEPATCH_H
> +#define _UAPI_LIVEPATCH_H
> +
> +#define KLP_RELA_PREFIX		".klp.rela."
> +#define KLP_SYM_PREFIX		".klp.sym."
> +
> +#endif /* _UAPI_LIVEPATCH_H */
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 61328328c474..622f1916a5c8 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -20,6 +20,7 @@
> =C2=A0#include <linux/completion.h>
> =C2=A0#include <linux/memory.h>
> =C2=A0#include <linux/rcupdate.h>
> +#include <uapi/linux/livepatch.h>
> =C2=A0#include <asm/cacheflush.h>
> =C2=A0#include "core.h"
> =C2=A0#include "patch.h"
> @@ -226,7 +227,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs,
> const char *strtab,
> =C2=A0
> =C2=A0		/* Format: .klp.sym.sym_objname.sym_name,sympos */
> =C2=A0		cnt =3D sscanf(strtab + sym->st_name,
> -			=C2=A0=C2=A0=C2=A0=C2=A0 ".klp.sym.%55[^.].%511[^,],%lu",
> +			=C2=A0=C2=A0=C2=A0=C2=A0 KLP_SYM_PREFIX "%55[^.].%511[^,],%lu",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 sym_objname, sym_name, &sympos);
> =C2=A0		if (cnt !=3D 3) {
> =C2=A0			pr_err("symbol %s has an incorrectly
> formatted name\n",
> @@ -305,7 +306,7 @@ static int klp_write_section_relocs(struct module
> *pmod, Elf_Shdr *sechdrs,
> =C2=A0	 * See comment in klp_resolve_symbols() for an explanation
> =C2=A0	 * of the selected field width value.
> =C2=A0	 */
> -	cnt =3D sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
> +	cnt =3D sscanf(shstrtab + sec->sh_name, KLP_RELA_PREFIX
> "%55[^.]",
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 sec_objname);
> =C2=A0	if (cnt !=3D 1) {
> =C2=A0		pr_err("section %s has an incorrectly formatted
> name\n",


