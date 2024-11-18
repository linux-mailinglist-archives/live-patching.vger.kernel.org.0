Return-Path: <live-patching+bounces-843-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B2A9D0F3D
	for <lists+live-patching@lfdr.de>; Mon, 18 Nov 2024 12:08:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6BEDB23EEC
	for <lists+live-patching@lfdr.de>; Mon, 18 Nov 2024 11:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4EF198A01;
	Mon, 18 Nov 2024 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ekl0NLE7"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1285B194A64
	for <live-patching@vger.kernel.org>; Mon, 18 Nov 2024 11:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731928006; cv=none; b=S4/LIodTgzxL3rJv3AHGCstBxIRNUp5TZBhpKlIlOLRw3alqZKa/LDaeVovIyrFcG0NCsvxHJrQkMVC2kAoAwO1b+lJhsCrqcgd1FUkTu+VvrNVZnk7YFWzk/zPUA45WfSwBUd/DR/fO7j+ip0/XjR4ENTJzwzOa0C4dWGPgkIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731928006; c=relaxed/simple;
	bh=IFcBtIn1LqFVelHm7kG7/Vy3ppN0z+ueq8gYg8sWEas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6xaeoVrTWohA6Nno+piV0FOQPuAo1rwP/4zPUbtvZwfLcnXTeRCfluZj1IWOrdabYMGVFbOi8Zxa9aQhmthuPUM8vurUWA+hJKG9nU7/wbBw+re5YucVz3fS1vySIiwpusAOifgsf9ktKAe55OtpsCw0XHHna6cgAlWqovkM+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ekl0NLE7; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38232cebb0cso1490600f8f.1
        for <live-patching@vger.kernel.org>; Mon, 18 Nov 2024 03:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731928002; x=1732532802; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q4K7ZFgLQYJQlGAzpq8RK54g3EqKOomWWOR+yhsr1qw=;
        b=ekl0NLE713WVl+0iqMFWCUeOyXGpS1GTBNAadeC6CjQrpdNj1R2nypLRGP2uJjakH3
         ma6jZAiH77JhVsgZkswVXE9+2l5Yia2YLgFg6gsC88yso321GFZfT27iEKVPgSJFNaM9
         2W2NPkP0iv4jC4RM8EWyzp5JMVGQUDyQPWB8SMNIP/y8oyb8Hywli7WQnPgfo82zPfG6
         rQCdFl5UhQJc+FctTaghJ0W1GD9XLogikkThFP7hwAl0gs65J49G1fTmGWNGUnJTfluX
         zSVJrdJLD7Qsye3TVFGals+IXJ9hPI7Ba9b3ytrQIA7bHxP9wm9EHtPjUxegLnu5oju/
         lOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731928002; x=1732532802;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4K7ZFgLQYJQlGAzpq8RK54g3EqKOomWWOR+yhsr1qw=;
        b=Q8Z3gD07wBf8QZixEs2uVWk/Dh+ZpLJQm4aRKQU55Fr6RZyOAAOUMYL7fbdrym3Pxy
         KQcQQ9ktfJVoX8I9Z/kN22jWh04V60uJZWr3Z4723E1n8H3UG4JPDANseAU9A5x0Ukw0
         zyn4GHCghEH9ISm9q0n0I9Ejo2RAjn+4W1RVV0Vv2b+0CNn0C1Aifu0MH+qsyALvORwb
         OJ+KJpbJ6YAAZ9hb/doeQ8I/vmQ47v/ZgAViqINPOQIDkXLYKhGpRzuEMblq33LhJ1NB
         eV6M21DHZNVd/fSuJPbVZlVuOlJfF9LpXbu8q13EX1zPNVO3pc17SB7rlqy8yDzLYsJW
         lKig==
X-Forwarded-Encrypted: i=1; AJvYcCVBvbcCYlm1xQJqaT2Q5YeeSRpvE6AqeTg34E1k9PEa4sr2NUrB5vaMlL4ScaGuBvYJCoOsB/KN/MPqhMqW@vger.kernel.org
X-Gm-Message-State: AOJu0YyOTZFPYRtplJBO4Vavvoyy4KhacyW8c3WBsl3kN+Om1LBy9FuV
	R8bqo1wtFtFKmoyZR+2q6ZU2UF2sE1pxxgF1c3Tr/r50TFhhCjbzibnsSsU7vvo=
X-Google-Smtp-Source: AGHT+IEHvVmgRYFNhCs4UC7E5RjVk5JwGYVdnUZOYcUXsiEIWSohYFEZO8cTVp2lMrq4C8xPl0BQ1Q==
X-Received: by 2002:a05:6000:18af:b0:37d:4ef1:1820 with SMTP id ffacd0b85a97d-38225a91e80mr10392779f8f.40.1731928002298;
        Mon, 18 Nov 2024 03:06:42 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38242eef982sm4319340f8f.8.2024.11.18.03.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 03:06:41 -0800 (PST)
Date: Mon, 18 Nov 2024 12:06:34 +0100
From: Petr Mladek <pmladek@suse.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Russell King <linux@armlinux.org.uk>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jeroen de Borst <jeroendb@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Russell King <linux+etnaviv@armlinux.org.uk>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Louis Peens <louis.peens@corigine.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v2 19/21] livepatch: Convert timeouts to secs_to_jiffies()
Message-ID: <Zzsfuuv3AVomkMxn@pathway.suse.cz>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v2-19-911fb7595e79@linux.microsoft.com>
 <718febc4-59ee-4701-ad62-8b7a8fa7a910@csgroup.eu>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <718febc4-59ee-4701-ad62-8b7a8fa7a910@csgroup.eu>

On Sat 2024-11-16 11:10:52, Christophe Leroy wrote:
> 
> 
> Le 15/11/2024 à 22:26, Easwar Hariharan a écrit :
> > [Vous ne recevez pas souvent de courriers de eahariha@linux.microsoft.com. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > Changes made with the following Coccinelle rules:
> > 
> > @@ constant C; @@
> > 
> > - msecs_to_jiffies(C * 1000)
> > + secs_to_jiffies(C)
> > 
> > @@ constant C; @@
> > 
> > - msecs_to_jiffies(C * MSEC_PER_SEC)
> > + secs_to_jiffies(C)
> > 
> > Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> > ---
> >   samples/livepatch/livepatch-callbacks-busymod.c |  2 +-
> >   samples/livepatch/livepatch-shadow-fix1.c       |  2 +-
> >   samples/livepatch/livepatch-shadow-mod.c        | 10 +++++-----
> >   3 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
> > index 378e2d40271a9717d09eff51d3d3612c679736fc..d0fd801a7c21b7d7939c29d83f9d993badcc9aba 100644
> > --- a/samples/livepatch/livepatch-callbacks-busymod.c
> > +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> > @@ -45,7 +45,7 @@ static int livepatch_callbacks_mod_init(void)
> >   {
> >          pr_info("%s\n", __func__);
> >          schedule_delayed_work(&work,
> > -               msecs_to_jiffies(1000 * 0));
> > +               secs_to_jiffies(0));
> 
> Using secs_to_jiffies() is pointless, 0 is universal, should become
> schedule_delayed_work(&work, 0);

Yes, schedule_delayed_work(&work, 0) looks like the right solution.

Or even better, it seems that the delayed work might get replaced by
a normal workqueue work.

Anyway, I am working on a patchset which would remove this sample
module. There is no need to put much effort into the clean up
of this particular module. Do whatever is easiest for you.

Best Regards,
Petr

