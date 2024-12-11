Return-Path: <live-patching+bounces-915-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B573B9EC2AF
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 04:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC1682840FB
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 03:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD161FCF78;
	Wed, 11 Dec 2024 03:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmcE4/lj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F7D195;
	Wed, 11 Dec 2024 03:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733886098; cv=none; b=ZQpQk5iefKYSH4lEV1e7TEkKZp4ymeRcFYp6v3PymiIrw7XdbgWvaeuzhupCMlC/jvuNZ9HB/QA7sZZk7+NqjT9MhQFjF8HcNsiWV+xqaveFHWb9FhpBtLbMvYvRqJQsUL8RUzrHuyBBVPFsjlNIwxt1qifUHDV1to0JvT5rWk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733886098; c=relaxed/simple;
	bh=08Gv+rg+muCd4b+QXxh4lSp3ciy5sU1jyZsQ2rNGCQs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qexHXYE5iMTL/9RBIRlxKnZ36TRzcGRdBz+8OOPsDeI9VH9lqz7NMWj0lylpamMDnulUoJZWydJfCMilRXrFweN0gC/1fGUGBkIBlD1ypvHjxhJqYjvGzuLEzLPmbV1ltTRWfThEiCoLVD8yfR3M3AOOYe5MCSNztrViL46LtHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmcE4/lj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C6C4CED6;
	Wed, 11 Dec 2024 03:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733886097;
	bh=08Gv+rg+muCd4b+QXxh4lSp3ciy5sU1jyZsQ2rNGCQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EmcE4/ljfCRY3RJanBjxtPhT62/nJjxk7ELO0ZGNbc2mhHWfd391knNb2HOuZGhSx
	 1e9fTFNcZABywOnqpoRKAEZbgjlix3qU4Qd2lcLQX3AgcLKJ4vrIgfKpyVm37bJMAM
	 wiwQScSc5AP2YRJa64ls0Q4PrRlmeIvzeFuzlqiXSS0E4b38+g1f5LgHQjP+e4bxxF
	 EWfJBUd/sx64BPsSVOGtlrnzPfoqLHGXyBoBKFxBYI5CCDVF2OYRXR0K/LPrQzVMJu
	 IZkEdyC65OkC/1hbUFTVO1xckc1Src7rjo3nhww+SaTgc+dkPD8qefo1Jh9IYKWx27
	 gFWQHpinQ+82w==
Date: Tue, 10 Dec 2024 19:01:33 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>, Jeff Johnson
 <jeff.johnson@oss.qualcomm.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Julia Lawall
 <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, Daniel Mack
 <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert
 Jarzmik <robert.jarzmik@free.fr>, Russell King <linux@armlinux.org.uk>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Ofir
 Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>, Lucas De
 Marchi <lucas.demarchi@intel.com>, Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=
 <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jeroen de Borst
 <jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 James Smart <james.smart@broadcom.com>, Dick Kennedy
 <dick.kennedy@broadcom.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Roger Pau =?UTF-8?B?TW9ubsOp?=
 <roger.pau@citrix.com>, Jens Axboe <axboe@kernel.dk>, Kalle Valo
 <kvalo@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, Marcel
 Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Florian Fainelli
 <florian.fainelli@broadcom.com>, Ray Jui <rjui@broadcom.com>, Scott Branden
 <sbranden@broadcom.com>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Xiubo Li <xiubli@redhat.com>, Ilya
 Dryomov <idryomov@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri
 Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek
 <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Louis Peens
 <louis.peens@corigine.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas
 Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, cocci@inria.fr,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, linux-mm@kvack.org,
 linux-bluetooth@vger.kernel.org, linux-staging@lists.linux.dev,
 linux-rpi-kernel@lists.infradead.org, ceph-devel@vger.kernel.org,
 live-patching@vger.kernel.org, linux-sound@vger.kernel.org,
 oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org, Anna-Maria Behnsen
 <anna-maria@linutronix.de>
Subject: Re: [PATCH v3 00/19] Converge on using secs_to_jiffies()
Message-ID: <20241210190133.44818a76@kernel.org>
In-Reply-To: <20241210185040.96c81a25f098f59191223c9f@linux-foundation.org>
References: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
	<315e9178-5b10-4de0-bdcf-7243e0e355bb@oss.qualcomm.com>
	<20241210153604.cf99699f264f12740ffce5c7@linux-foundation.org>
	<20241210173548.5d32efe0@kernel.org>
	<20241210183130.81111d05148c41278a299aad@linux-foundation.org>
	<20241210184129.41aaf371@kernel.org>
	<20241210185040.96c81a25f098f59191223c9f@linux-foundation.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 18:50:40 -0800 Andrew Morton wrote:
> > > Very unlikely, and any such conflict will be trivial.  
> > 
> > Agreed, mainly I don't understand why we'd make an exception
> > and take the patchset via a special tree.  
> 
> It saves work for everyone?
> 
> The patches are super-simple.  If a maintainer chooses to merge one of
> them, Stephen tells us and I drop the mm.git copy.  It's all so easy.

If it's just to save work - we're fine.
Please don't apply the networking changes.

