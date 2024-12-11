Return-Path: <live-patching+bounces-920-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE289EC5D9
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 08:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D940E188244B
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 07:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58DB11C5F3C;
	Wed, 11 Dec 2024 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaN44Yyj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7692770B;
	Wed, 11 Dec 2024 07:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733903144; cv=none; b=GzDdI8hzaLQn2L/XfHrecY7IjZbvhKwZT7Dd5/iy6ywS2PencOYkUYj+LW0z9lwpbb2MoXTwZyVzeUWJtd6Atz4GySrrr1K7+UGKJLSfYQyACJAhWZa3OVEPKqTcJ1JaHdMRW/3zOnMLdJZi73C/OdpF64/gmLG2JA5gWoDb+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733903144; c=relaxed/simple;
	bh=KM5Of7mM53fIwBBiaYiiUQ9BfxtVrpykBzubAzmUdlE=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=Re7CwYGk0kjql/dgwi39nC3/6P1g4Qr2/BpXTFBnYXbW45mzbuTXRJbChPY6v+HMXcylNM54cu2dK2BL28fNR/oinvTj/pj273ukDI4ga6KLK3+U6g2qv4nTxIdNUQ57ljUBIBGcxHRuuORmx9AK2bo+r3bGpZiu+0yzceHYVNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaN44Yyj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A77C4CED2;
	Wed, 11 Dec 2024 07:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733903143;
	bh=KM5Of7mM53fIwBBiaYiiUQ9BfxtVrpykBzubAzmUdlE=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=ZaN44YyjhRMRn1ZZ+GmTOS40UgIRbhL4wBsfJy8XjSPG4QXarlwE2h8LLmlSyCwwE
	 mhsyVMxQDuDVaxW28PxQeU8er7lMNhKnh1DPb1k4CbIDr8a5tkumkBV/uTN9xwnFYp
	 h1HNwJmQE+rv8LC4BNlfDvTcPd5XXQGZmdVG4PmZqn4aLOwa4oWj50GSY3CEXVAf2K
	 4s9JO62HtV4AyzHzBTTKIyxerUXbJDme/tcsfk9nrdzoiXAN6SWU/JWU3UcTsBRxgt
	 rxzg89ETMye2AN+BOVUz+OAR29EzCnQNdPIoMqWIY7xMbpGfvp3pWcUv4qGp3pyh75
	 7MY47GTKlC4gQ==
From: Kalle Valo <kvalo@kernel.org>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik
 <kadlec@netfilter.org>,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,  Julia Lawall
 <Julia.Lawall@inria.fr>,  Nicolas Palix <nicolas.palix@imag.fr>,  Daniel
 Mack <daniel@zonque.org>,  Haojian Zhuang <haojian.zhuang@gmail.com>,
  Robert Jarzmik <robert.jarzmik@free.fr>,  Russell King
 <linux@armlinux.org.uk>,  Heiko Carstens <hca@linux.ibm.com>,  Vasily
 Gorbik <gor@linux.ibm.com>,  Alexander Gordeev <agordeev@linux.ibm.com>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Sven Schnelle
 <svens@linux.ibm.com>,  Ofir Bitton <obitton@habana.ai>,  Oded Gabbay
 <ogabbay@kernel.org>,  Lucas De Marchi <lucas.demarchi@intel.com>,  Thomas
 =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,  Rodrigo
 Vivi
 <rodrigo.vivi@intel.com>,  Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>,  Maxime Ripard <mripard@kernel.org>,
  Thomas Zimmermann <tzimmermann@suse.de>,  David Airlie
 <airlied@gmail.com>,  Simona Vetter <simona@ffwll.ch>,  Jeroen de Borst
 <jeroendb@google.com>,  Praveen Kaligineedi <pkaligineedi@google.com>,
  Shailend Chand <shailend@google.com>,  Andrew Lunn
 <andrew+netdev@lunn.ch>,  James Smart <james.smart@broadcom.com>,  Dick
 Kennedy <dick.kennedy@broadcom.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>,  Roger Pau =?utf-8?Q?Monn=C3=A9?=
 <roger.pau@citrix.com>,
  Jens Axboe <axboe@kernel.dk>,  Jeff Johnson <jjohnson@kernel.org>,
  Catalin Marinas <catalin.marinas@arm.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jack Wang <jinpu.wang@cloud.ionos.com>,
  Marcel Holtmann <marcel@holtmann.org>,  Johan Hedberg
 <johan.hedberg@gmail.com>,  Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Florian Fainelli
 <florian.fainelli@broadcom.com>,  Ray Jui <rjui@broadcom.com>,  Scott
 Branden <sbranden@broadcom.com>,  Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,  Xiubo Li <xiubli@redhat.com>,
  Ilya Dryomov <idryomov@gmail.com>,  Josh Poimboeuf <jpoimboe@kernel.org>,
  Jiri Kosina <jikos@kernel.org>,  Miroslav Benes <mbenes@suse.cz>,  Petr
 Mladek <pmladek@suse.com>,  Joe Lawrence <joe.lawrence@redhat.com>,
  Jaroslav Kysela <perex@perex.cz>,  Takashi Iwai <tiwai@suse.com>,  Louis
 Peens <louis.peens@corigine.com>,  Michael Ellerman <mpe@ellerman.id.au>,
  Nicholas Piggin <npiggin@gmail.com>,  Christophe Leroy
 <christophe.leroy@csgroup.eu>,  Naveen N Rao <naveen@kernel.org>,
  Madhavan Srinivasan <maddy@linux.ibm.com>,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org,
  netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,  cocci@inria.fr,
  linux-arm-kernel@lists.infradead.org,  linux-s390@vger.kernel.org,
  dri-devel@lists.freedesktop.org,  intel-xe@lists.freedesktop.org,
  linux-scsi@vger.kernel.org,  xen-devel@lists.xenproject.org,
  linux-block@vger.kernel.org,  linux-wireless@vger.kernel.org,
  ath11k@lists.infradead.org,  linux-mm@kvack.org,
  linux-bluetooth@vger.kernel.org,  linux-staging@lists.linux.dev,
  linux-rpi-kernel@lists.infradead.org,  ceph-devel@vger.kernel.org,
  live-patching@vger.kernel.org,  linux-sound@vger.kernel.org,
  oss-drivers@corigine.com,  linuxppc-dev@lists.ozlabs.org,  Anna-Maria
 Behnsen <anna-maria@linutronix.de>,  Jeff Johnson
 <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH v3 14/19] wifi: ath11k: Convert timeouts to
 secs_to_jiffies()
References: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
	<20241210-converge-secs-to-jiffies-v3-14-ddfefd7e9f2a@linux.microsoft.com>
	<87sequr7ho.fsf@kernel.org>
Date: Wed, 11 Dec 2024 09:45:24 +0200
In-Reply-To: <87sequr7ho.fsf@kernel.org> (Kalle Valo's message of "Wed, 11 Dec
	2024 09:42:11 +0200")
Message-ID: <87o71ir7cb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Kalle Valo <kvalo@kernel.org> writes:

> Easwar Hariharan <eahariha@linux.microsoft.com> writes:
>
>> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
>> secs_to_jiffies(). As the value here is a multiple of 1000, use
>> secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.
>>
>> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
>> the following Coccinelle rules:
>>
>> @@ constant C; @@
>>
>> - msecs_to_jiffies(C * 1000)
>> + secs_to_jiffies(C)
>>
>> @@ constant C; @@
>>
>> - msecs_to_jiffies(C * MSEC_PER_SEC)
>> + secs_to_jiffies(C)
>>
>> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
>> ---
>>  drivers/net/wireless/ath/ath11k/debugfs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> I assume we can take this to our ath.git tree, please let us know if
> that's not the case.

Nevermind, I now saw the discussion in the cover letter and assume that
this patch will be sent separately.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

