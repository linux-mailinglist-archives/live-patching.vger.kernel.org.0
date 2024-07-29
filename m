Return-Path: <live-patching+bounces-415-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C1793F8F7
	for <lists+live-patching@lfdr.de>; Mon, 29 Jul 2024 17:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D2C02812A5
	for <lists+live-patching@lfdr.de>; Mon, 29 Jul 2024 15:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E05155342;
	Mon, 29 Jul 2024 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuSOx5Bx"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E729874E09
	for <live-patching@vger.kernel.org>; Mon, 29 Jul 2024 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722265395; cv=none; b=HhaF+T2cLbZHikcECMEpF3Koljdq3ztyGK4GYmaRgQP5RNZGIBFVzt/0kF3xYrJDbafuDBQi4r2XHd1Fs01OlCtfdZVzjGpJPya9R5bIse2g8ugVd1uTO3gAH9Rl01MWYlrRe8D3OZCNdW0gPPdeT9ZO35ktV7xE/QPHBHzkM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722265395; c=relaxed/simple;
	bh=XxX2aRn/fmXfvkXJiGI7i95D4RMJaHU/4lQA5qKFhEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qygfhWvKGvNXdcLnRbwVljY8A/KVsgOk2028pGT6acjmp+lAXsTkaKh9pTu2+lQyoC6p5yGZOtx9dmjgD2IbFQ9a9asac74gVN/MqPLxVzEn8iozOmH6p6hC69CqexAV6HkZsUhPYKx4XDy3K8gXAEpdBO3wbuX7w/qaWBgoWqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuSOx5Bx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722265392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc+mhczrJ1nkvAWktInjEDKrDKX570Q/kD7809NJ9Ro=;
	b=iuSOx5BxJ0UzGSYleoAESZbOnRhsx26OW5abDmWTES7xV+pxXP4vcaUXEuf+/PskyjZ5Fs
	lAEVftWOPY3MVTLjL2jAIxazfr4ZB6maWhWXLY1v41pFMQ2Vo3FwP0Dzx2tdLsNnXwlEop
	RWFXYoICKjNNWocmeeJwURSE50rc1n8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-wr2rRBWJNkK-it_mCdlYxQ-1; Mon,
 29 Jul 2024 11:03:08 -0400
X-MC-Unique: wr2rRBWJNkK-it_mCdlYxQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B86B91944D30;
	Mon, 29 Jul 2024 15:03:04 +0000 (UTC)
Received: from sullivan-work.redhat.com (unknown [10.22.9.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93C0F300019D;
	Mon, 29 Jul 2024 15:02:50 +0000 (UTC)
From: Ryan Sullivan <rysulliv@redhat.com>
To: live-patching@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Cc: rysulliv@redhat.com,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jikos@kernel.org,
	jpoimboe@kernel.org,
	naveen.n.rao@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	mpe@ellerman.id.au,
	npiggin@gmail.com
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on livepatch sibling call
Date: Mon, 29 Jul 2024 11:02:36 -0400
Message-ID: <20240729150246.8939-1-rysulliv@redhat.com>
In-Reply-To: <878qxkp9jl.fsf@mail.lhotse>
References: <878qxkp9jl.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hello Michael,

In the case of no sibling call within the livepatch then the store is  
only "restoring" the r2 value that was already there as it is stored  
and retrieved from the livepatch stack. The only time that the r2 value  
is corrupted is in the case of a sibling call and thus this additional  
store is just restoring the caller's context as a safety precaution.  
Also should this explanation be put into the patch itself or will these  
messages suffice as a reference?

Cheers,

Ryan


