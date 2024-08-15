Return-Path: <live-patching+bounces-499-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C739537EB
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 18:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E539286CAA
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 16:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BC21B3749;
	Thu, 15 Aug 2024 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wr0eX9EO"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F9517C9B2
	for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738072; cv=none; b=Mikm8izk/GeO/ATxdfnO7G1LCViSoyjxI8Mgb4F9Z8R3Y7tGckPkWYI4BijyPRZw6WGg4h682tj1vb9NjSoCpzMeMwLzVLnQXspasAXfv83Fq7MRJ8kYTTjSkA/yPTOONpIXd6iZF8moLCe3LOLnCusf85acv22BcH8Fi8DcPB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738072; c=relaxed/simple;
	bh=5pUYRO75yh/LJGZRwuhYQEWzY1cqQeZmjxFUYT3k/R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQmqZK+N3q0p1KUfxpul7iwQiJY+DcSU7gB05drI4MUt/9sKpBOpvlrR1OO1YuE84FNpI31YcPKIZiZyu4acddiOsieusRRrlbwShRW3UE69kDuqxTHHYNKiALb4b1WnXLqQi1SD8rHWEvL6sKlOxd2BN2MWc0tTRuN155lYFyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wr0eX9EO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723738070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sTHy0VTZhp+zpCxqk4Vm43LA+qs7m6Yc40H41bHyaao=;
	b=Wr0eX9EOuQbqoQExvt/cUHuBprEuYy/k44GiQn9b+ru4W7EeUQ7PVZs55i90vyL8VHa9Fw
	pWsfpAyQSsWL6DafQAgUmg0F3TWShVDezA2a5pbF7LKafBo+Mr6Q0aqcISzuVcyyFkTFto
	0a6W1qXLpcIw6Y+GEjEElwl3MG/eV1I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-CJq-W_2tPkO0yu1adDEvNg-1; Thu,
 15 Aug 2024 12:07:44 -0400
X-MC-Unique: CJq-W_2tPkO0yu1adDEvNg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA2C71955D48;
	Thu, 15 Aug 2024 16:07:41 +0000 (UTC)
Received: from sullivan-work.redhat.com (unknown [10.22.32.144])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 360CE1955F66;
	Thu, 15 Aug 2024 16:07:38 +0000 (UTC)
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
Date: Thu, 15 Aug 2024 12:07:07 -0400
Message-ID: <20240815160712.4689-1-rysulliv@redhat.com>
In-Reply-To: <87ed6q13xk.fsf@mail.lhotse>
References: <87ed6q13xk.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Michael,

The r2 value is stored to the livepatch stack prior to entering into 
the livepatched code, so accessing it will gurantee the previous value
is restored.

Also, yes, this bug is caused by tooling that "scoops out" pre-compiled
code and places it into the livepatch handler (e.g. kpatch). However, 
since the large majority of customers interact with the livepatch 
subsystem through tooling, and this fix would not pose any serious risk
to either usability or security (other than those already present in 
livepatching), plus it would solve a large problem for these tools with
a simple fix, I feel as though this would be a useful update to 
livepatch.

Thanks,

Ryan


