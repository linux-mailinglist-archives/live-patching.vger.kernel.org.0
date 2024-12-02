Return-Path: <live-patching+bounces-875-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3B19E0DD3
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 22:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC0D2B2DCF7
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 21:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CA51DF27E;
	Mon,  2 Dec 2024 21:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMEYBPPm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FC61DE4E6;
	Mon,  2 Dec 2024 21:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733174227; cv=none; b=SCnsruMCvLhcpoOl8GsnrS3oX18H653uuB8h2URo3IiRK+ADow3hMAmBhWZCHqiReJSfW7kdW88Fr37CmvOVZ8qkozmJAn0u28KRXrxgl+QHzJXL4/HNIqJF9PrLHLH5xZWU7QiUizAn0blZVksB48HRaqtes4y7CMjOT1BR9mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733174227; c=relaxed/simple;
	bh=c/OpwCh+/t+1IaSytHBg7Vl7CNyrcqGFhU7wyEfSfVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m+wccwUEQ76V5ZFR+JICaxhnujZ2uVj3snLQ5Pu+CJlT1pUTH6oMrEiRmY8sFcwrudFFjSG0oS0X4j5X+zTuv6vMO8xMd/x69XF2sQ+dmPZ2wuYjWYPJc6xq1amKGhzldwEZf3XXzhDc1Tr3fpxDiTE1u0ikYWBzHPYZ1nPDDHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMEYBPPm; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2eeb64f3588so1309034a91.2;
        Mon, 02 Dec 2024 13:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733174225; x=1733779025; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FZHtDSci4mxW9uObrOpyGXF4tVtVRk+OAevn+2+RUUc=;
        b=bMEYBPPmUSzzFVLj9dAXVxkG7SkFjX0RJ9DXF00gd9JPnqb1y0BE+QqO/OfCo8+9zL
         E3xw4ZetVenH0ISfG7FI2kNitWbxPHzm8dRWOXJSU2qLIVxHvx0kolgC107d7xGUSKq4
         v+arcQYsDBBPzxLpFgDjZ4cV53opsDDu4cpOG6tKzRm+4Q/CWr/fdHZXvTkjaO4z6FJw
         JW8/wFLTPFs3dOcmd/W/XioTSaLtHwLHZCSrBeBu+nFViATugRRwMiabDMaNTfZghJUW
         CVR3flE3Qzl3NNECSuD/bCnXOPEt9BkqzBXNzEYNH4IhHbD943pFZQ7TEzBlhqCD34uC
         qGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733174225; x=1733779025;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FZHtDSci4mxW9uObrOpyGXF4tVtVRk+OAevn+2+RUUc=;
        b=Qg0iUV6aEDbtErdlOiEJmfERDIcKe8k2PVZ3igqRozFzURvnF0s1nRbZooAVUrqjjv
         PjL3OurKaWDHgW5dWk3w32O2O1vRkX4VNWMD4VR1vbCBdD50x957FphDQVLtAWHSEHJC
         8Jmj8XRugz57Z3dFCUS3NBYRFtxQHabiROVSBJZvnhaqI2fACd1+UNU/QRTd1Db6Jy8h
         1qalxz/uWXYDdP2PY8XSaGm1m1IRHFmXunMqEakwnCOYbtl290Op2ONG/+c6e7OgB43/
         j/qtMXCu6293zaroFJDzRbslqWPVuxukroppKnnZmyz18ZFUS5qK/7DYlihKyDh/Nm9R
         CFsw==
X-Forwarded-Encrypted: i=1; AJvYcCUeSIiWgPUlGzcXhpqF+ZYvjGe8r9nCQiU98EF9WQkhUwaDe787END7bB3EefnJNPBVha00zoKrSL/2vw==@vger.kernel.org, AJvYcCUlpgLldE4AOaELzYpHoJPsJFAn96PIHCf6cTJeZXWuhNQJ0XdxwLT63hfHClcEL3WeJW7w3bgI8HlCx+Q=@vger.kernel.org, AJvYcCUtEu9iWdDWJZ4MBf6HFEqynzaSVPmozu/fuu3UR76i4CDMdx1kQgPTbEsio1IYE1ie96P7g7aoCMOgf+l2zRVk@vger.kernel.org, AJvYcCVAeqE6Gt/HWXKSQKP7UhAfX/XbmFmsUC0RlikhylITWMPqPi85dRGlXy5LCg2h3G/l0LDq2R1CSg8EofRCS/0=@vger.kernel.org, AJvYcCVL6m0HvMGF0gtdcrsLqDJehgFgLSBP9V3FeBkH3OmZpoDcdcMu75wVhqI/lWk57oAPu73znVpWijBI80Y=@vger.kernel.org, AJvYcCVnrIsuMGZoTtv0geGluA8WVEOK9++V3LPUKJ4Yje0r/Hk0UMPQSNoLqAFUudCZQrZ4IH9ejLEJcJULxw==@vger.kernel.org, AJvYcCWoruJmMJHeDyBieTZFO4wD2lEwGBgXFeooR5pIEobKQwWwDsfK9XjihvNHNkj+VnOeEkOu1F7Iyr2yLEf/@vger.kernel.org, AJvYcCX+Iug9e9L896KXYAYQRKzZCZSqwleuIk7bxg5uF+CBDny5kBemu2X64YRRFjzJHiINN/XCg3x1zRKG@vger.kernel.org, AJvYcCX4Sq30BqUje9a7bonyx9qAeEqz1qSmp1THIo5EYauvCRou4qJosyeppNow53OMHujNED1lTa3vgPnR4HDN7uuF@vger.kernel.org, AJvYcCXD
 tcmbbuEq3ICDfUBDDMq7FI8mIIjTJ/0Om7J36RjzfnSFn+cTmTxOD8cJlIxIjhXD00YRrvAL@vger.kernel.org, AJvYcCXPt1F0JHF7LsQCvlLAkF7VxP9xmVVCcuK3cB7WKUqXEW4mwgy+aOqbehvcadMFvnH6MGwwJ1Yyaq+Xf8IonQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPJZlwK7dPN9pLNRIuHOE2/WA78m3phmhIEdcEjOQuLbKW98ha
	21Yu3kncqtWbUEXzy1b/gBOqCqPI6BiAIuywOoF/NpMGngvqxj5RlnguoW5005nZffctAs+7cVM
	hSLN4opAynq3uTZBaJRE1U5tY7kU=
X-Gm-Gg: ASbGncvWyXY1AAzpsWgNREUsofaF0rtF3wK0vcBy8Kqr37RHZdpEkJwDX1Tgou+u58J
	clh7aXq3m+4xvqW6reB++a/iQUsDvfA==
X-Google-Smtp-Source: AGHT+IFDh1yb6d6zM40EzPJelJu2iVMH0WClLwmjysRWgfnYNSB8awfS5UuhO/EqqMc0eH1dffTLKgwFM99xaAmy4L8=
X-Received: by 2002:a17:90b:1c09:b0:2ee:3cc1:793a with SMTP id
 98e67ed59e1d1-2ef0124c720mr32029a91.29.1733174224966; Mon, 02 Dec 2024
 13:17:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v2-9-911fb7595e79@linux.microsoft.com>
In-Reply-To: <20241115-converge-secs-to-jiffies-v2-9-911fb7595e79@linux.microsoft.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 2 Dec 2024 22:16:53 +0100
Message-ID: <CAH9NwWdjXKH-AcKa-prwdqj2JqWLYVp1qM+0kxtQYSwo1J1c7g@mail.gmail.com>
Subject: Re: [PATCH v2 09/21] drm/etnaviv: Convert timeouts to secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, 
	Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, 
	Robert Jarzmik <robert.jarzmik@free.fr>, Russell King <linux@armlinux.org.uk>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ofir Bitton <obitton@habana.ai>, 
	Oded Gabbay <ogabbay@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>, 
	Shailend Chand <shailend@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
	Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Ray Jui <rjui@broadcom.com>, 
	Scott Branden <sbranden@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Lucas Stach <l.stach@pengutronix.de>, Russell King <linux+etnaviv@armlinux.org.uk>, 
	Louis Peens <louis.peens@corigine.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org, 
	linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-scsi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-block@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-mm@kvack.org, linux-bluetooth@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-rpi-kernel@lists.infradead.org, 
	ceph-devel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-sound@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

>
> Changes made with the following Coccinelle rules:
>
> @@ constant C; @@
>
> - msecs_to_jiffies(C * 1000)
> + secs_to_jiffies(C)
>
> @@ constant C; @@
>
> - msecs_to_jiffies(C * MSEC_PER_SEC)
> + secs_to_jiffies(C)
>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>

> ---
>  drivers/gpu/drm/etnaviv/etnaviv_cmdbuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_cmdbuf.c b/drivers/gpu/drm/etnaviv/etnaviv_cmdbuf.c
> index 721d633aece9d4c81f0019e4c55884f26ee61c60..0f5a2c885d0ab7029c7248e15d6ea3c31823b782 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_cmdbuf.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_cmdbuf.c
> @@ -100,7 +100,7 @@ int etnaviv_cmdbuf_init(struct etnaviv_cmdbuf_suballoc *suballoc,
>                 mutex_unlock(&suballoc->lock);
>                 ret = wait_event_interruptible_timeout(suballoc->free_event,
>                                                        suballoc->free_space,
> -                                                      msecs_to_jiffies(10 * 1000));
> +                                                      secs_to_jiffies(10));
>                 if (!ret) {
>                         dev_err(suballoc->dev,
>                                 "Timeout waiting for cmdbuf space\n");
>
> --
> 2.34.1
>


-- 
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy

