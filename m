Return-Path: <live-patching+bounces-1121-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA41FA2AC09
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 16:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE3293A74DA
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 15:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCA11EA7D1;
	Thu,  6 Feb 2025 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oqQ70vf1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4251E5B91
	for <live-patching@vger.kernel.org>; Thu,  6 Feb 2025 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738854136; cv=none; b=CQd2cJSB4NrTIfCpDLYsDmcPckO8fVf+CdJfyF9i2vLPGmTY0NIKSCxztbW4RPkwqDx/vRcJSaxaNaYVUDPXuvA1lrJJuTPhu3tuVAjmQgRl0aZa4+FnNRONJh1dpjjAL+4N/3EQQ88JfmDhxDfD5bGJ5l6qN/zVekyUuCckNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738854136; c=relaxed/simple;
	bh=0C3us8bkwGCphww5CtGnGjWm5gBeMGmbRP1C44zKX5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lzKqcWvWAuBRu8i9SEI0y6sR4HDKzi3NV50+mdTIcNrPiPhsCXY15WSvtuW2HzqOc/QvMYQZOc5N4yVi1+a+I+Ag2GUyCXYga346jjjPBO9KiClLT76fWV1Eq+GcqA5rnZJ7jXHsaje5SIxzAZVicFX2iH94yG2uysjlUAnbtkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oqQ70vf1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f4666364bso3938095ad.2
        for <live-patching@vger.kernel.org>; Thu, 06 Feb 2025 07:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738854134; x=1739458934; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8JIB6d7R5kKl6+damfWRxYdrapnjk0INN1HmKYI0wY=;
        b=oqQ70vf1087+FwoiOxKXnQgqEiYZG5KzHusbd89HlzHGu1+GjaSZ8evMIE0v0hW59K
         7w5EMHaFwhToQLrTt3+YR36A1X+culwRbnr6POn2iAsrPomzPhBZ/Ost8wUitYI4rmuq
         CW1wfoG1cbGSdTdoSXha5An9/2CSp9ZeyCwMzd2n2weCWUc22TwXkfUA0DPJANZO/TeG
         C+5WX/oh9iiVR2FXbiYLFsEB3VA/yxSnrfvyT7qB2GJLfuTF1J+kMMDhAsa4slNAknNn
         nqKSk5uyj3+yxZKaYCi9khRK+7644gO4cZCUX7OHEYfb4vDCNwQO7bcP+YbVQAAxlfOK
         bXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738854134; x=1739458934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r8JIB6d7R5kKl6+damfWRxYdrapnjk0INN1HmKYI0wY=;
        b=iPU3/OAUG2xOrBfDhIqhfBlvCWleM7cbeHUuZvZDk9vlM3wSy3VckJ0cr3Ptor8vEP
         9wME9ZYPk8kdJDVHYH/sF7/bIK3DRisj38L64PGeA0/4UO/9/qHMYfKT7OX6fPC6eRqF
         7sVHMzHnHLwCNOdfrdc/wqrFzQGHPZLLc0DwtuQjad64Jg7h/tq78vIdcZKk8WwxvHln
         U5LJH+enxvlAi1+lj49T0dxE+0pCkcXVeZlMyy5gsSAuhWi4bh7Ap39jPwS2mlvXmx61
         Hdpft1QH4B9R6eXXM8ykuiEX6NDVa1x+ML2plRB34LNtM16Zd1CciV/zp87zMJH4wXSl
         IQCA==
X-Forwarded-Encrypted: i=1; AJvYcCVRazbeUXnkUdBcKS82msUV7WKywxEXRv/1Yj7ib49GsneaN82b7rEcxp7q7boG2fd9KgEWzvQV38+/zZSd@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9fTIrA3t1YI4oo7DO19OROzhaCzP35OfBqG6Zn21JBRNfNiZX
	/zhPndR1m2APLL0rDWeitXfqCcRd9+ZPPPyaXKdziRVRfGGR+BDG9onAdnS0qe7vd+CH3gynNw=
	=
X-Google-Smtp-Source: AGHT+IE/pkwOkH9gpTz/SBuNLKZB4tv6JFu6biVE5oxwhrNUKnmXYncr6SL+F14kZKDgOV7jBcW5hq8JMQ==
X-Received: from pgbfq3.prod.google.com ([2002:a05:6a02:2983:b0:ad5:bda:6aef])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d481:b0:21f:3abc:b9fc
 with SMTP id d9443c01a7336-21f3abcbac0mr21818855ad.6.1738854133684; Thu, 06
 Feb 2025 07:02:13 -0800 (PST)
Date: Thu,  6 Feb 2025 15:02:12 +0000
In-Reply-To: <mb61pwme55kuw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <mb61pwme55kuw.fsf@kernel.org>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250206150212.2485132-1-wnliu@google.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Weinan Liu <wnliu@google.com>
To: puranjay@kernel.org
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org, 
	live-patching@vger.kernel.org, mark.rutland@arm.com, peterz@infradead.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org, 
	wnliu@google.com
Content-Type: text/plain; charset="UTF-8"

> After some debugging this is what I found:
> 
> devtmpfsd() calls devtmpfs_work_loop() which is marked '__noreturn' and has an
> infinite loop. The compiler puts the `bl` to devtmpfs_work_loop() as the the
> last instruction in devtmpfsd() and therefore on entry to devtmpfs_work_loop(),
> LR points to an instruction beyond devtmpfsd() and this consfuses the unwinder.
> 
> ffff800080d9a070 <devtmpfsd>:
> ffff800080d9a070:       d503201f        nop
> ffff800080d9a074:       d503201f        nop
> ffff800080d9a078:       d503233f        paciasp
> ffff800080d9a07c:       a9be7bfd        stp     x29, x30, [sp, #-32]!
> ffff800080d9a080:       910003fd        mov     x29, sp
> ffff800080d9a084:       f9000bf3        str     x19, [sp, #16]
> ffff800080d9a088:       943378e8        bl      ffff800081a78428 <devtmpfs_setup>
> ffff800080d9a08c:       90006ca1        adrp    x1, ffff800081b2e000 <unique_processor_ids+0x3758>
> ffff800080d9a090:       2a0003f3        mov     w19, w0
> ffff800080d9a094:       912de021        add     x1, x1, #0xb78
> ffff800080d9a098:       91002020        add     x0, x1, #0x8
> ffff800080d9a09c:       97cd2a43        bl      ffff8000800e49a8 <complete>
> ffff800080d9a0a0:       340000d3        cbz     w19, ffff800080d9a0b8 <devtmpfsd+0x48>
> ffff800080d9a0a4:       2a1303e0        mov     w0, w19
> ffff800080d9a0a8:       f9400bf3        ldr     x19, [sp, #16]
> ffff800080d9a0ac:       a8c27bfd        ldp     x29, x30, [sp], #32
> ffff800080d9a0b0:       d50323bf        autiasp
> ffff800080d9a0b4:       d65f03c0        ret
> ffff800080d9a0b8:       97f06526        bl      ffff8000809b3550 <devtmpfs_work_loop>
> ffff800080d9a0bc:       00000000        udf     #0
> ffff800080d9a0c0:       d503201f        nop
> ffff800080d9a0c4:       d503201f        nop
> 
> find_fde() got pc=0xffff800080d9a0bc which is not in [sfde_func_start_address, sfde_func_size)
> 
> output for readelf --sframe for devtmpfsd()
> 
> func idx [51825]: pc = 0xffff800080d9a070, size = 76 bytes
>     STARTPC           CFA       FP        RA
>     ffff800080d9a070  sp+0      u         u
>     ffff800080d9a07c  sp+0      u         u[s]
>     ffff800080d9a080  sp+32     c-32      c-24[s]
>     ffff800080d9a0b0  sp+0      u         u[s]
>     ffff800080d9a0b4  sp+0      u         u
>     ffff800080d9a0b8  sp+32     c-32      c-24[s]
> 
> The unwinder and all the related infra is assuming that the return address
> will be part of a valid function which is not the case here.
> 
> I am not sure which component needs to be fixed here, but the following
> patch(which is a hack) fixes the issue by considering the return address as
> part of the function descriptor entry.
> 
> -- 8< --
> 
> diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
> index 846f1da95..28bec5064 100644
> --- a/kernel/sframe_lookup.c
> +++ b/kernel/sframe_lookup.c
> @@ -82,7 +82,7 @@ static struct sframe_fde *find_fde(const struct sframe_table *tbl, unsigned long
>         if (f >= tbl->sfhdr_p->num_fdes || f < 0)
>                 return NULL;
>         fdep = tbl->fde_p + f;
> -       if (ip < fdep->start_addr || ip >= fdep->start_addr + fdep->size)
> +       if (ip < fdep->start_addr || ip > fdep->start_addr + fdep->size)
>                 return NULL;
> 
>         return fdep;
> @@ -106,7 +106,7 @@ static int find_fre(const struct sframe_table *tbl, unsigned long pc,
>         else
>                 ip_off = (int32_t)(pc - (unsigned long)tbl->sfhdr_p) - fdep->start_addr;
> 
> -       if (ip_off < 0 || ip_off >= fdep->size)
> +       if (ip_off < 0 || ip_off > fdep->size)
>                 return -EINVAL;
> 
>         /*
> 
> -- >8 --
> 
> Thanks,
> Puranjay

Thank you for reporting this issue.
I just found out that Josh also intentionally uses '>' instead of '>=' for the same reason
https://lore.kernel.org/lkml/20250122225257.h64ftfnorofe7cb4@jpoimboe/T/#m6d70a20ed9f5b3bbe5b24b24b8c5dcc603a79101

QQ, do we need to care the stacktrace after '__noreturn' function?

