Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796FD69B91E
	for <lists+live-patching@lfdr.de>; Sat, 18 Feb 2023 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBRJaj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 18 Feb 2023 04:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBRJaj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 18 Feb 2023 04:30:39 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137302A157;
        Sat, 18 Feb 2023 01:30:36 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id i12so152104pgj.11;
        Sat, 18 Feb 2023 01:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fyAvZg2BEsMeP6/jUzzdf7X656IDoOYn+3Yl6U0o7Gc=;
        b=HFOl5clPHIip9DwFviEW9qZXUmqKf85fuUphY2NtDqlgzDZfypUmYMhVcrG+EHTDQ7
         QgKnoHRbKHh3o+ETz+prg1ju8BdmqjAlbBPqhchr55EtShEU7DWx1rNOHYqHiBl39c8I
         oSkO2blYCF6XB2dcwcIBaNKgBckSpVfWxt/t9XuNEp2+/pXQSDoMNfW3lXKuy4mL8Gc4
         WI58D/xPuAtZ/HBX2fvnCLzh9DeCdShCYoDM920Z4/majlYDwVTdd9k3mvLCnD0spCMW
         3Y+FNmRru1oyO+ozh0vgTe1gyf+7fAQdbjpaUmfqJA0yMaF5He6HSrgjUEO2vvw4PKPC
         POew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fyAvZg2BEsMeP6/jUzzdf7X656IDoOYn+3Yl6U0o7Gc=;
        b=2Goy/Z8QiSDoYM5n0/d6Awm4DXbCf8TVRVoU5DbRjkmrJ7KrWH3BabaX/+h3rWxwm3
         mnEIc9UwqdDTOBKdvFljIF0YiZ09CNQi1HPUaAz4XhLTcabCTg2TUpiXWFajz21ZLO2p
         6rWix4nepa66gNInlWjavlzxKwSo9CLnr/nGeceCkFvha09R4t0jV3BRKaehgEqJzLN/
         +1MrA2KsEklNN4MoMISufsYUMMFzIJy14SDsp3IwBKuqKJE7z3xQNgG1uRz4P2H4W7sf
         ifl54XVC3qZ75uco9eS71+PMed6C0tpaWbtdvFBbDb806hFu1gv6cXo3xbDR3JJxNqEy
         HDjg==
X-Gm-Message-State: AO0yUKUyb9hhvubQW/MTNOFoHfpGgMjjAMxc+Vwlil0ZjIJgWq01YLnx
        uwftY2hK0GS1H9NOHbhleXM=
X-Google-Smtp-Source: AK7set8qHLW8n6BjMoJgJ7G/I4iPbvXmcV6NEueDxndw3n4bdj+uTZGN9r1ZCbLUqUHEfvM9MSDYWA==
X-Received: by 2002:a62:7911:0:b0:5a9:c16f:b4ea with SMTP id u17-20020a627911000000b005a9c16fb4eamr6654303pfc.7.1676712635481;
        Sat, 18 Feb 2023 01:30:35 -0800 (PST)
Received: from freeip.amazon.com ([205.251.233.50])
        by smtp.googlemail.com with ESMTPSA id j11-20020a62e90b000000b005b08595af07sm625792pfh.137.2023.02.18.01.30.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Feb 2023 01:30:34 -0800 (PST)
Message-ID: <a1b83a8d621e37310194c0c32b9d847a0952d282.camel@gmail.com>
Subject: Re: [RFC PATCH v3 05/22] objtool: Reorganize ORC types
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     madvenka@linux.microsoft.com, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 18 Feb 2023 17:30:20 +0800
In-Reply-To: <20230202074036.507249-6-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
         <20230202074036.507249-1-madvenka@linux.microsoft.com>
         <20230202074036.507249-6-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 2023-02-02 at 01:40 -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> The ORC code needs to be reorganized into arch-specific and generic
> parts
> so that architectures other than X86 can use the generic parts.
> 
> orc_types.h contains the following ORC definitions shared between
> objtool
> and the kernel:
> 
> 	- ORC register definitions which are arch-specific.
> 	- orc_entry structure which is generic.
> 
> Move orc_entry into a new file include/linux/orc_entry.h. Also, the
> field
> names bp_reg and bp_offset in struct orc_entry are x86-specific.
> Change
> them to fp_reg and fp_offset. FP stands for frame pointer.
> 
> Currently, the type field in orc_entry is only 2 bits. For other
> architectures, we will need more. So, expand this to 3 bits.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com
> >
> ---
>  arch/x86/include/asm/orc_types.h       | 37 +++++-------------------
>  include/linux/orc_entry.h              | 39
> ++++++++++++++++++++++++++
>  tools/arch/x86/include/asm/orc_types.h | 37 +++++-------------------
>  tools/include/linux/orc_entry.h        | 39
> ++++++++++++++++++++++++++
>  tools/objtool/orc_gen.c                |  4 +--
>  tools/objtool/sync-check.sh            |  1 +
>  6 files changed, 95 insertions(+), 62 deletions(-)
>  create mode 100644 include/linux/orc_entry.h
>  create mode 100644 tools/include/linux/orc_entry.h
> 

[snip]

> diff --git a/tools/include/linux/orc_entry.h
> b/tools/include/linux/orc_entry.h
> new file mode 100644
> index 000000000000..3d49e3b9dabe
> --- /dev/null
> +++ b/tools/include/linux/orc_entry.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2017 Josh Poimboeuf <jpoimboe@redhat.com>
> + */
> +
> +#ifndef _ORC_ENTRY_H
> +#define _ORC_ENTRY_H
> +
> +#ifndef __ASSEMBLY__
> +#include <asm/byteorder.h>
> +
> +/*
> + * This struct is more or less a vastly simplified version of the
> DWARF Call
> + * Frame Information standard.  It contains only the necessary parts
> of DWARF
> + * CFI, simplified for ease of access by the in-kernel unwinder.  It
> tells the
> + * unwinder how to find the previous SP and BP (and sometimes entry
> regs) on
> + * the stack for a given code address.  Each instance of the struct
> corresponds
> + * to one or more code locations.
> + */
> +struct orc_entry {
> +	s16		sp_offset;
> +	s16		fp_offset;
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	unsigned	sp_reg:4;
> +	unsigned	fp_reg:4;
> +	unsigned	type:3;
> +	unsigned	end:1;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	unsigned	fp_reg:4;
> +	unsigned	sp_reg:4;
> +	unsigned	unused:4;
> +	unsigned	end:1;
> +	unsigned	type:3;
> +#

nit:
I believe you also need to update fp_reg/bp_offset -> fp_reg/fp_offset
in orc_dump() in orc_dump.c

- Suraj

> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* _ORC_ENTRY_H */
> diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
> index dd3c64af9db2..68c317daadbf 100644
> --- a/tools/objtool/orc_gen.c
> +++ b/tools/objtool/orc_gen.c
> @@ -98,7 +98,7 @@ static int write_orc_entry(struct elf *elf, struct
> section *orc_sec,
>  	orc = (struct orc_entry *)orc_sec->data->d_buf + idx;
>  	memcpy(orc, o, sizeof(*orc));
>  	orc->sp_offset = bswap_if_needed(orc->sp_offset);
> -	orc->bp_offset = bswap_if_needed(orc->bp_offset);
> +	orc->fp_offset = bswap_if_needed(orc->fp_offset);
>  
>  	/* populate reloc for ip */
>  	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int),
> R_X86_64_PC32,
> @@ -149,7 +149,7 @@ int orc_create(struct objtool_file *file)
>  
>  	struct orc_entry null = {
>  		.sp_reg  = ORC_REG_UNDEFINED,
> -		.bp_reg  = ORC_REG_UNDEFINED,
> +		.fp_reg  = ORC_REG_UNDEFINED,
>  		.type    = UNWIND_HINT_TYPE_CALL,
>  	};
>  
> diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-
> check.sh
> index ee49b4e9e72c..ef1acb064605 100755
> --- a/tools/objtool/sync-check.sh
> +++ b/tools/objtool/sync-check.sh
> @@ -18,6 +18,7 @@ arch/x86/include/asm/unwind_hints.h
>  arch/x86/lib/x86-opcode-map.txt
>  arch/x86/tools/gen-insn-attr-x86.awk
>  include/linux/static_call_types.h
> +include/linux/orc_entry.h
>  "
>  
>  SYNC_CHECK_FILES='

