Return-Path: <live-patching+bounces-829-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA199CFD1D
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 08:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 435EE1F25103
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 07:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0EA193064;
	Sat, 16 Nov 2024 07:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r5iZGNuE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7E1190067
	for <live-patching@vger.kernel.org>; Sat, 16 Nov 2024 07:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731743977; cv=none; b=cbk2pu0lm7Om0vDbIb9wyr2fScIpCtJwpxqoZwa2O/FWled/drs9rUPqrCUL7NMKQty946QDUNIyfs0+VQcIYs1Q/eNgFUWEWc7aLj2KssuiiHz/h+/b/THflJcXYs+qVH8ggeF/BjOOi0u9vpWwXZbCOx4eZfhP+zdQjvnQZrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731743977; c=relaxed/simple;
	bh=syAVCylnhi0AytBImEtkvzButQ9wsAguk45yhcS0NNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrmPg3bCCjmCIvJ6v48VEoSgcmZtgVBpCwcWqb0jYVVtbVQwXOcKbPwKXc+X+Oti9PPdQwojaERKeuF3e9FQLAZcrYuA7vvkxhbCFknh4ZFTVo+WMyUo+DjMoQ8/1uCmvTONcBqvhLRtYDWwfAn4PdsY251ekglwqx94s3/z/b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r5iZGNuE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-431616c23b5so14427625e9.0
        for <live-patching@vger.kernel.org>; Fri, 15 Nov 2024 23:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731743973; x=1732348773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xrsdExZKqTlwoTRHJD0ZdQo7yx2uU25FrNS0bU2S5+Y=;
        b=r5iZGNuEOfNWbi26gs/0hDufWiKU9glpkrz83hfYdk20o+8yDMVRsyZ6+cPIv/oaQN
         1kDE9R6Vr8IhLeyXsibSIWi+i5grPibUr8CgcnTKyayifBg26F0iK5NCf/Zk+pdy13Hu
         08u3dXU0sR2s59y+fza8gG5ZMw0Hfg8Sa3w3izBxsCrCB2Hfi3yWK+5VciZPLCvYZRaJ
         Cm3dD99wasOBV+Vb4KvuHLxcD9cr9PRrdBxQ3n8LlNaCQDaVlvqQLTJ3YxibOJsA3aud
         mNDVaqD9+G+4jwsF6k6bmfL3lgB8UhWpAIV/7hICAk042PQXjY0vP86Sl31MhmWRTiq6
         Ag5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731743973; x=1732348773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrsdExZKqTlwoTRHJD0ZdQo7yx2uU25FrNS0bU2S5+Y=;
        b=ec4H0w8YhLnI5rrqLYNLbVCf0QU3vVLBUCh00+3jAuWZqeB9z3tuQGv+vLvWAM+EFt
         3u+1GpKHssn+leTWHEkGC1TojeuxOpQQKqL4aC7Gg9lEAHL8QUnixPKzjjqx2nKateuA
         l8KBiSdhABpx5uoDjsx/eD2oCIZr5U2vWWPmxv0UA58FBcRbprVW1Ow1jLZt2fTtZU9a
         siuIjpVrjquALQJ+3TIcc3L1h3FrP+6WfaX1pUMOAqcJRS+JZxZIUpTNiu5Pl7wl+JRv
         LT7LEtq1C4EAjG3PWD49qjxv7FPbEMfXd4jxdeIf0Z7AUlJXWgdhM/lulO8hFJr1HptK
         b2TQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcVcaY8P6f3QxpiMNAWJWYd8Nx4ujRdPDC1TwGBQLQdiElx+9MUDd2Ipftq6in1/HTVx8lQPM6cYtmAEtx@vger.kernel.org
X-Gm-Message-State: AOJu0YyAG381nKmHdVaG7BvPtXukYaB5/yraj220uiLTvfMBLeHrIww9
	420jFKCujzVLLHH07qtuvVehGUSgS0sdvtJZ02vWYWbHadYihiplgcO42uXhySk=
X-Google-Smtp-Source: AGHT+IHwPca/r8TengkDOJBkzNMy5+IC+M/DjfY5vaIp0XwfqGKX+JdkORZRtZVKPaDZkydKQ4+r2A==
X-Received: by 2002:a05:600c:19cb:b0:431:559d:4103 with SMTP id 5b1f17b1804b1-432defe3203mr49400585e9.7.1731743973417;
        Fri, 15 Nov 2024 23:59:33 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dab806e1sm81445685e9.20.2024.11.15.23.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 23:59:32 -0800 (PST)
Date: Sat, 16 Nov 2024 10:59:29 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
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
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Russell King <linux+etnaviv@armlinux.org.uk>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Louis Peens <louis.peens@corigine.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
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
Subject: Re: [PATCH 19/22] livepatch: Convert timeouts to secs_to_jiffies()
Message-ID: <896c656f-6d8c-4337-8464-7557c43a80ab@stanley.mountain>
References: <20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v1-19-19aadc34941b@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115-converge-secs-to-jiffies-v1-19-19aadc34941b@linux.microsoft.com>

On Fri, Nov 15, 2024 at 09:22:49PM +0000, Easwar Hariharan wrote:
> diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
> index 378e2d40271a9717d09eff51d3d3612c679736fc..d0fd801a7c21b7d7939c29d83f9d993badcc9aba 100644
> --- a/samples/livepatch/livepatch-callbacks-busymod.c
> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> @@ -45,7 +45,7 @@ static int livepatch_callbacks_mod_init(void)
>  {
>  	pr_info("%s\n", __func__);
>  	schedule_delayed_work(&work,
> -		msecs_to_jiffies(1000 * 0));
> +		secs_to_jiffies(0));

Better to just call schedule_delayed_work(&work, 0);

>  	return 0;
>  }

regards,
dan carpenter

