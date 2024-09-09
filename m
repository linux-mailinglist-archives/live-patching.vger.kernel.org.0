Return-Path: <live-patching+bounces-637-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA19971F54
	for <lists+live-patching@lfdr.de>; Mon,  9 Sep 2024 18:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 721FD1C239EA
	for <lists+live-patching@lfdr.de>; Mon,  9 Sep 2024 16:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0144165F02;
	Mon,  9 Sep 2024 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q+cLooWJ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3C6165F17
	for <live-patching@vger.kernel.org>; Mon,  9 Sep 2024 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725899641; cv=none; b=uKNzTgezjumW0jP+JiKiySwoU1h07s9/+ABGtyPfH/zBlct7LCKTnwxKbE0yPvXwHcWP0dsAAzU3SfIvKZonr3J/b40Wt7cQoVo4b6NNExC3MVEAEf1C21suEkIIOfUl6D/kqZ/PYGGMjVgMFz/ZVD3QtgRGs+Yk2qRlCLGZ4u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725899641; c=relaxed/simple;
	bh=njyAw6Qco0Epfex9ue5oV/2XA/8xT3xiq9OESk/+LPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIOxqfQBIYsUvW+H+ibpY1cCgY2CL/YX/gEYgS4Ic3K3RKi8kzTkKB+a1Mq2h+FmATayQB6FabWU4FeAU4KvfvJicaXTPZtN16nLQ9FNsI5qWFRJtRHkttipIYHKkgGtzm3AMexcsiF8lCQAkJQtFoTKM4hbSRjhp+g3CxWPVSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q+cLooWJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725899638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njyAw6Qco0Epfex9ue5oV/2XA/8xT3xiq9OESk/+LPA=;
	b=Q+cLooWJbSnyCKJmI0rl6k2L4L7cI5RsI5NHWVcuCJuEz2A6z4zatJCYPzdeUpwRPdtKA+
	6mXx1tt5/jq3NMvl+q3ADkhqr27l7FocadlHOMCCG1zdIpAJ6icBkwQth+l5CsmvKTHG+G
	EzTa2fYL7LAu/JIHf1iUfh0wDL3ZOQ8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-2N4Dzd8JN7-keabLSWWOHw-1; Mon,
 09 Sep 2024 12:33:54 -0400
X-MC-Unique: 2N4Dzd8JN7-keabLSWWOHw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E39A51955DCE;
	Mon,  9 Sep 2024 16:33:51 +0000 (UTC)
Received: from sullivan-work (unknown [10.22.65.158])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D591195608A;
	Mon,  9 Sep 2024 16:33:47 +0000 (UTC)
Date: Mon, 9 Sep 2024 12:33:45 -0400
From: "Ryan B. Sullivan" <rysulliv@redhat.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	pmladek@suse.com, mbenes@suse.cz, jikos@kernel.org,
	jpoimboe@kernel.org, naveen.n.rao@linux.ibm.com,
	christophe.leroy@csgroup.eu, mpe@ellerman.id.au, npiggin@gmail.com
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on
 livepatch sibling call
Message-ID: <Zt8jaSQjpwtfJaVx@sullivan-work>
References: <87ed6q13xk.fsf@mail.lhotse>
 <20240815160712.4689-1-rysulliv@redhat.com>
 <9ec85e72-85dd-e9bc-6531-996413014629@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ec85e72-85dd-e9bc-6531-996413014629@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hello all,

Just wanted to ping and see if there was any further feedback or
questions regarding the patch?

--
Ryan


