Return-Path: <live-patching+bounces-767-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729E29BF596
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2024 19:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AC0D1C20FA1
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2024 18:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE6B208969;
	Wed,  6 Nov 2024 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SpP2b/+q"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEB3204F72
	for <live-patching@vger.kernel.org>; Wed,  6 Nov 2024 18:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730918852; cv=none; b=CY52QTAKtKwaty+rSIg0O9+vBFJzTMr7D1sgTQ9cLDgkGNmaIPAwSTTKSXVwDHYSCCItuiZ39E+wSTCqDgDQH8BREoVHg37V1at0pFDpxk8ry4vjaWaUR/a39t6dH1dQZ1zz9xt+Bq597Csa3YTSs/z4ai48tufUTO8YnS9CMjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730918852; c=relaxed/simple;
	bh=Exqe8iAbGSGFmpY63vbdFYXXt5TTkypiNy6jnutfI7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qEN4N/zQN+nZlmVgrLhvvUSHSiVW/MI/Ivven7XdJ4toF47fOcQtMJYHTT1TJHUsBZlA7ULKKQTLKBIYsbUcdU6TkC5KQ4OI6tamc/TCbEVXK/m3uf6j0s15VgP9JtMm+wyGnHxRIgBeZtkZc39eP1YrYL5ixG6+BSmBKOMKQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SpP2b/+q; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315ee633dcso22315e9.1
        for <live-patching@vger.kernel.org>; Wed, 06 Nov 2024 10:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730918848; x=1731523648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dGrUXDC8J5pqSkCVeKC3N6enHQma720hZqyIMlE1hY=;
        b=SpP2b/+qby5XWTbnicG3upZYrlXn4YDT6g4NTbcECe0GtoJrL3GuBllteEGEP8zXsl
         Wpwi+MZ0zBRf+h0PpWRkKJLfZ4w3g9bbeoBiX4fGfziKM/n5Xw1ta+UDBDTXJgNysYWO
         wWWS0d23hfAFqyvQWakhdUZf/qno2ZUIJwY/ZR+L1iCqa6MrkSRaXukrxJfoS4fsaaJt
         fFZaX7zSY1TC5OpuPyr0QxN5yrlGTKn3GJxQIMJK+EvKSqZYece7me/m9ega4jfCqWiP
         AGwRmID5eOuarhUKaU5qwrdkGZ6h7SF6CEFjhq66O/d7Fk5+uwZWZ10SUxNTzmSdEc2J
         7BiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730918848; x=1731523648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dGrUXDC8J5pqSkCVeKC3N6enHQma720hZqyIMlE1hY=;
        b=Knr0/GD4dccTiztqprkR8zXnMx8XWJ7AcqJrWsYgoDmDk4TBbyVx45x39syScWTuWm
         dpzSVQdiZE2CjAovRt/0kLgWJ9m+tuEVVvo9wZEm71lRrvQnS/UJ67W6Pd4PJ/7oIMY5
         yQwRbqkXtAJPN94R517ROEMhRvRXJKZwNpuhSPvyfCiShnVkyX4PSvlJ5R1xee4qCHbX
         lMjJlH0Rbf7fsZigVY1YMuKdef5R3vuVPuVnyksT0MmUXjhsTuEV/cbygUP4FchZKx61
         5Zqcqb/ZzqzsP/POBWE4ea7yb8I87j3dW7+KkEZfi1G5K/ShOe462e/VvBEthV6XWnbe
         44aA==
X-Forwarded-Encrypted: i=1; AJvYcCWHhDwVaqwWePtWDkwUrxi6UFUv37jgacvRXWa8zG8XbhCcTFSX51jPJKONAy8NL4WSPzRzdZ8DfbfmGWeU@vger.kernel.org
X-Gm-Message-State: AOJu0YyJyGL07tAtKKjedDTx3jE7LovaSY0iwg0NVx3WE3283OGFG0CB
	/J//Q6V9+PPAMkA5OjnD1q737TGlWivbYglt27+2Yhbh2h+VPp0GSpGUWxDWlpRl2r7X5Vft4mk
	0rMcrvcKvRmNfMf4AP9nG0bmBCPlZllz99fVD
X-Gm-Gg: ASbGncu3KEHDlXqKVGwz+paLWFTQgs3eBDtt2IN759fAkUiEk5ic5qN8vssy1d4Uec6
	nTaieUfCfLX1/tWVUyw75oU6cBK19J5b63NUrUgBpKKcJUq7GiYtJof26Qb4=
X-Google-Smtp-Source: AGHT+IEoEPmxnp0ZrudFR7joTbzlQj+R3HBGqdcNc8Wo/wQ4UlmCH/EpGH3i6KaycnwSNh8sQa+mrw9pRNPmOLCn904=
X-Received: by 2002:a05:600c:a3a8:b0:42b:a8fc:3937 with SMTP id
 5b1f17b1804b1-432af2ed605mr633765e9.4.1730918847928; Wed, 06 Nov 2024
 10:47:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106002401.283517-1-mcgrof@kernel.org>
In-Reply-To: <20241106002401.283517-1-mcgrof@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 6 Nov 2024 18:46:48 +0000
Message-ID: <CABCJKueDJuAz30=Wat5D1-V9eYzAbP7wAY61Fgzw_KZJcHWiSw@mail.gmail.com>
Subject: Re: [PATCH] tests/module/gen_test_kallsyms.sh: use 0 value for variables
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	petr.pavlu@suse.com, da.gomez@samsung.com, masahiroy@kernel.org, 
	deller@gmx.de, linux-arch@vger.kernel.org, live-patching@vger.kernel.org, 
	kris.van.hees@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Wed, Nov 6, 2024 at 12:24=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> Use 0 for the values as we use them for the return value on init
> to keep the test modules simple. This fixes a splat reported
>
> do_init_module: 'test_kallsyms_b'->init suspiciously returned 255, it sho=
uld follow 0/-E convention
> do_init_module: loading module anyway...
> CPU: 5 UID: 0 PID: 1873 Comm: modprobe Not tainted 6.12.0-rc3+ #4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 2024.08-1 09/18/=
2024
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x56/0x80
>  do_init_module.cold+0x21/0x26
>  init_module_from_file+0x88/0xf0
>  idempotent_init_module+0x108/0x300
>  __x64_sys_finit_module+0x5a/0xb0
>  do_syscall_64+0x4b/0x110
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7f4f3a718839
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff>
> RSP: 002b:00007fff97d1a9e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 000055b94001ab90 RCX: 00007f4f3a718839
> RDX: 0000000000000000 RSI: 000055b910e68a10 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 00007f4f3a7f1b20 R09: 000055b94001c5b0
> R10: 0000000000000040 R11: 0000000000000246 R12: 000055b910e68a10
> R13: 0000000000040000 R14: 000055b94001ad60 R15: 0000000000000000
>  </TASK>
> do_init_module: 'test_kallsyms_b'->init suspiciously returned 255, it sho=
uld follow 0/-E convention
> do_init_module: loading module anyway...
> CPU: 1 UID: 0 PID: 1884 Comm: modprobe Not tainted 6.12.0-rc3+ #4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 2024.08-1 09/18/=
2024
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x56/0x80
>  do_init_module.cold+0x21/0x26
>  init_module_from_file+0x88/0xf0
>  idempotent_init_module+0x108/0x300
>  __x64_sys_finit_module+0x5a/0xb0
>  do_syscall_64+0x4b/0x110
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7ffaa5d18839
>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  lib/tests/module/gen_test_kallsyms.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/tests/module/gen_test_kallsyms.sh b/lib/tests/module/gen=
_test_kallsyms.sh
> index ae5966f1f904..3f2c626350ad 100755
> --- a/lib/tests/module/gen_test_kallsyms.sh
> +++ b/lib/tests/module/gen_test_kallsyms.sh
> @@ -32,7 +32,7 @@ gen_num_syms()
>         PREFIX=3D$1
>         NUM=3D$2
>         for i in $(seq 1 $NUM); do
> -               printf "int auto_test_%s_%010d =3D 0xff;\n" $PREFIX $i
> +               printf "int auto_test_%s_%010d =3D 0;\n" $PREFIX $i
>                 printf "EXPORT_SYMBOL_GPL(auto_test_%s_%010d);\n" $PREFIX=
 $i
>         done
>         echo

Looks good to me. Thanks!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami

