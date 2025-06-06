Return-Path: <live-patching+bounces-1493-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B89CACFBC5
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 05:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 322413AE4C1
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 03:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646531D5AC0;
	Fri,  6 Jun 2025 03:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gih1XeeC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DEB2AF10;
	Fri,  6 Jun 2025 03:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749182319; cv=none; b=sBWsO5Fyy9YTZCsSF7uIPXNBm4ZMzXo3YPvlJJLIQyf1kXtvcmubXoktfJJWcIC9+wM33mOfsaxQpwHkGUwPgJvIRcMo4B/beZUPQ5bvAp44ZDIYXeanLBGt06oiHcGxuUd1mlL6nqeRtlmCMy3NN6DeZsaGe424kHOoJPY5Veg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749182319; c=relaxed/simple;
	bh=LK5X69/i8uytmySC0Z4Ou4eF+gW0edvu7mo0a1cKgH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZkeBAa5i0RGRsuhoBXDU9tiUc9ySLtGygp08YHXJxa/rVDrvbJstDjG60a+dGPqC1FUNTe/GwhlsTbpkdNIDwy16TKi8meKTNozWfHLIKaWomzwHtX1c8egr305ftxWcSXcGbCVtMFbU8rgnjzMcQF7dXfh1F7Ik2LAZ0sn4Frw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gih1XeeC; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3105ef2a06cso13778581fa.2;
        Thu, 05 Jun 2025 20:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749182316; x=1749787116; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQSiUXDNQHY8TEOJoD5lf68SefdIzR97xDvLD9jV7r0=;
        b=Gih1XeeCd4TBY9ck4/IzUmOGfvQT9KSwCTNkOoOlHer/yMPLdxMkER5QigUIB/5Vyj
         v69Vva/X74HNuihrqHl1H1XXKwHPezu2RZrQgFBzI+WwcVFviy+55g9ONVVo22UvVJ7H
         lG7iX/NHrnc+TXQea2aH9FwsJPgKebn/hk/XeWpUTu6dwBZuPAGaGXaiCH/Q7umWVAmI
         rxUVUD3bi4cw7F6PQrlGUKwlMIzHLO/E37qZYJzjb4ODdwm/9eHITTO1DgRRFVitG/jS
         RCl9X6rcOri/Ic8Xrw+81mbJPCyYkqxa5sbLzpXaTSeirdJiVLAIn0AZ2RnCMSWqVhA6
         2qUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749182316; x=1749787116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQSiUXDNQHY8TEOJoD5lf68SefdIzR97xDvLD9jV7r0=;
        b=US/0zMRhTYWptDxSn+5ioeW91eNAYYSPnRmg6SAs46SCWt4qkOCNG9/VzUMgSDf/bn
         dDRibGcYTH21j5RwytxB8OCpBnfWvDOhpMqPc0anx5FSII1+eo/OxyZc9AnSF9PByFhf
         aW0HPSpVsMtxmczOcRI4IV6vD6+eZiGmNhR93vbjgMbSuRi1V6AvUVhsPrZYtM8nbvT+
         YdN6tK7M7UJo6xHvi84R9cp9bWX/v+33/6EFIo328gM4j/jt7zaDezaF24GzsHvOmpTP
         PPzgnlZtFURI1tjABcCk9rIV3xkLWU69HrMajrZZhnl98nOAtkJMFWDSvX6LR9NfDbCy
         Qosw==
X-Forwarded-Encrypted: i=1; AJvYcCU1/U1GvsPe6Tw6QAvjHSMgjkfdnKLOFlKZ4F2JNp7b0SZgiiWw3Zkj2jaLglcnC3C1x8mtPAUBwnE8g+cD2w==@vger.kernel.org, AJvYcCUozu5dQ86h36U6bnU19ctrMGtzPLagS0Z/oTribaWgtkWZ1XUXGRwqdUGAB/a5k23Q+7LS9MQ+m2Sh1rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwIWelgZpuP2tInRUv1MSumHhxQgN2EUkQ5OPw++SZKy8vOns7
	7N1INEtEKa/wNje3wcWZmxp5vKn7YTyrLtKv4Uaj2ixEggsvS0UNO14s+J3TSiwr4iqeWQkEw7q
	vCfjG5uv47fbzji5PctVj/6uo4VcjOA==
X-Gm-Gg: ASbGncviOm2wKCGU7Tsq8gnSQWmz6IgoGRJClyeczGgcK3WgWxH1qiYnQPmVgOUMkh4
	0HJJy6SZLiuz8Ay4TLpv1gCVajHjK06nfHS0uMQkACspptKEHqGxaXA/wppTreoCV3kUWZ2DmsP
	8tzydwC405EYMfuo1BkCDEI0ueCZin2dBzVpwa/Rg9WneUCW5nOljdukZ2zQ==
X-Google-Smtp-Source: AGHT+IHKVxTrbYQexN6YYe6K3FUKs1myKjdfhUcFF+Kk6G/BAcfhn3Gls7Aae9KMozwA23Bm8Bkt4+k+T2a7XUrL6p0=
X-Received: by 2002:a05:651c:2227:b0:32a:8030:7004 with SMTP id
 38308e7fff4ca-32adfb0006emr3994291fa.4.1749182315293; Thu, 05 Jun 2025
 20:58:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1746821544.git.jpoimboe@kernel.org> <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
In-Reply-To: <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 5 Jun 2025 23:58:23 -0400
X-Gm-Features: AX0GCFuqciui2GauEEhvuIFEtnV30WN-mx2DXNp9H5pVfjv_HSvst-dPUDz1E2Q
Message-ID: <CAMzpN2jbdRJWhAWOKWzYczMjXqadg_braRgaxyA080K9G=xp0g@mail.gmail.com>
Subject: Re: [PATCH v2 45/62] x86/extable: Define ELF section entry size for
 exception tables
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 4:51=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> In preparation for the objtool klp diff subcommand, define the entry
> size for the __ex_table section in its ELF header.  This will allow
> tooling to extract individual entries.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/include/asm/asm.h | 20 ++++++++++++--------
>  kernel/extable.c           |  2 ++
>  2 files changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> index f963848024a5..62dff336f206 100644
> --- a/arch/x86/include/asm/asm.h
> +++ b/arch/x86/include/asm/asm.h
> @@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr(voi=
d *p)
>
>  # include <asm/extable_fixup_types.h>
>
> +#define EXTABLE_SIZE 12

Put this in asm-offsets.c instead.  That removes the need for the
BUILD_BUG_ON().


Brian Gerst

