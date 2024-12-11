Return-Path: <live-patching+bounces-913-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2389F9EC261
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 03:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACAB0280ECF
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 02:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D101FCCF2;
	Wed, 11 Dec 2024 02:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Da4qREKh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A09983CDA;
	Wed, 11 Dec 2024 02:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733884894; cv=none; b=fZFatDuVXf7d6kXB4yxWc4HVIhq6CtOhNBxH3xhGH6RuGoHGppSlyi93Y5hd/AsI5Cu2KdhOSL66R4TMYalYpJgUIG9ixrzXPAavVEL/EKZvpmmPJfhUUah1TYcVJ8TgW1nWhYIs7Wk06o7AIR1DWNtZSfDc/FE49oKEnBb1HsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733884894; c=relaxed/simple;
	bh=00K8MMiI4zi+Ut/RW/eta+vMQomu0Giei3szpffQQOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwavUJfhfGhWBRICXK/JkbZwip66AWOJahROKVbqj+ETuMByvPMjjxfsvTCC5p8LgEAOdS00QMeqI2L7C+2Snaqpaxg92buweCLokfwCu5bqxypDqeDHRlgyK5Wpz2g8H+5v3NETUQelJyuh/6pxtXI/5Wi0ONmFDsh4JSfz4q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Da4qREKh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2728C4CED6;
	Wed, 11 Dec 2024 02:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733884894;
	bh=00K8MMiI4zi+Ut/RW/eta+vMQomu0Giei3szpffQQOQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Da4qREKhLmCm8yz23HYMcnYhvUPIhwEMSq3e2xy5eHqmd+lk3xFCqCL8gMV2d1qZM
	 OX/nYhIL+8FVEAH5j2G8jreOCn4t5aDyk2A67ZSa2Mkyc9Pdlwt9HWePiQrPKYupQD
	 HqnoKIQmX31F4DdpsyABbQ15F6Ui5dY/VyDtBpBstL8y1jhriA+kdAfBMPTAXFbWnS
	 63C0vjQwg5Lmz+BJiiuG775DcGC4erU4pOGbFjbFCfGrajmvqQlFUpggTSjU+aLgVs
	 HKqzofl4MBLxzwaLLU/QjjetYigVK4WMW1awwyb5uskvci+1KuE5L5PLpPOgzSWNQz
	 YP2aWNyh8AjbA==
Date: Tue, 10 Dec 2024 18:41:29 -0800
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
Message-ID: <20241210184129.41aaf371@kernel.org>
In-Reply-To: <20241210183130.81111d05148c41278a299aad@linux-foundation.org>
References: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
	<315e9178-5b10-4de0-bdcf-7243e0e355bb@oss.qualcomm.com>
	<20241210153604.cf99699f264f12740ffce5c7@linux-foundation.org>
	<20241210173548.5d32efe0@kernel.org>
	<20241210183130.81111d05148c41278a299aad@linux-foundation.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 18:31:30 -0800 Andrew Morton wrote:
> > > I'll just grab everything and see if anyone complains ;)  
> > 
> > I may, if this leads to a conflict :(  
> 
> Very unlikely, and any such conflict will be trivial.

Agreed, mainly I don't understand why we'd make an exception
and take the patchset via a special tree.

> > Easwar, please break this up per subsystem.  
> 
> The series is already one-patch-per-changed-file.

More confusingly still, they did send one standalone patch for 
an Ethernet driver:
https://lore.kernel.org/all/20241210-converge-secs-to-jiffies-v3-20-59479891e658@linux.microsoft.com/
And yet another Ethernet driver (drivers/net/ethernet/google/gve/) 
is converted in this series.

