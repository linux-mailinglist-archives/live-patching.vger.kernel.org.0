Return-Path: <live-patching+bounces-2043-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FIjDhrVlWnFVAIAu9opvQ
	(envelope-from <live-patching+bounces-2043-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 16:04:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB21A157429
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 16:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE7FE30088BC
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 15:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6980433D6C6;
	Wed, 18 Feb 2026 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNfmcDo2"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0003133A9EF
	for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771427094; cv=none; b=kBSFhOiF5byrJI+82TrT37JDgzM+yAtmAy5XGbZ23fHWa/NBBZ+F1GK83Fc6irMRzxH4jCubkgTdazL8aseznQjRDzfJ1nDUQtspt9DvKFJmf+AMAjix8HM86LmzjAtUvi9W2YUK4Ccw5PFLBrP4lUedwqwTDxHsYjMzjZPGv7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771427094; c=relaxed/simple;
	bh=bBPvJ3ts8hZuOs+pqqOwN+giWLiQXb2A1Dker1A3RFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4fLwsJQKHWXxD5lqjdHFPEGyDm32+23LJK+/ZJPDkd9o5vdG1u+Eq8BxrcD+HmXQKOBN0IYoGjrNXWIJZWdzVrQ0lzo+8ate+hXMW3JAbhhv+5thD88KR2+pgLHmtA2T4XkICFfQpm5RlFYC0vScpn8v3ecQDOTQjXOYGuTw/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNfmcDo2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771427092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWN98mczuSIyV1BWwzNIEJuEatBqWuUn6SrS6GvOuRA=;
	b=fNfmcDo2+gIByPJgMZ+/BjYQLBNjTuucpyASSqNLF+n3xrL/oB9uVtuT1KGpIQOHbBHo73
	OkOljB4xb+WvQaHODxqOBEUtzfk0vzhTiMioPcK0IlZ4oMrGtKSAAozJRhYzwJrpOC+y0U
	Cr2rZ8Fsg8Hpd3WAYkQRWevwPTEKVBI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-a4XNsCLSNY-tyW5A4tRNFQ-1; Wed,
 18 Feb 2026 10:04:46 -0500
X-MC-Unique: a4XNsCLSNY-tyW5A4tRNFQ-1
X-Mimecast-MFC-AGG-ID: a4XNsCLSNY-tyW5A4tRNFQ_1771427085
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B01D1955F14;
	Wed, 18 Feb 2026 15:04:45 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 845691800666;
	Wed, 18 Feb 2026 15:04:43 +0000 (UTC)
Date: Wed, 18 Feb 2026 10:04:40 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when
 short-circuiting
Message-ID: <aZXVCIuSdlk6f-1K@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
 <CAPhsuW55E-T0gg4zFitjVB81+y5wHPEQ0665MDPnznV9=9Y1+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW55E-T0gg4zFitjVB81+y5wHPEQ0665MDPnznV9=9Y1+g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2043-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AB21A157429
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:25:13AM -0800, Song Liu wrote:
> On Tue, Feb 17, 2026 at 8:17 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
> [...]
> > > 2.53.0
> > >
> > >
> >
> > Maybe I'm starting to see things, but when running 'S 2' builds, I keep
> > getting "vmlinux.o: changed function: override_release".  It could be
> > considered benign for quick development work, or confusing.  Seems easy
> > enough to stash and avoid.
> 
> "-S 2" with a different set of patches is only needed in patch development,
> but not used for official releases. Therefore, I agree this is not a real issue.
> 

My use case was running a series of tests:

  (test 1) - full build with -T
  (test N) - short circuit with -S 2 -T
  ...

and where it confused me was that I had created tests which were
designed to fail, specifically one wanted to verify no changes found
for the recountdiff change in this set.

Without this patch, that test will succeed as the version glitch gets
picked up as:

  vmlinux.o: changed function: override_release

I could work around that in verification, but then I miss the *specific*
failure report from klp-build.  I could also run each individual test as
full, but each build was taking ~6 minutes on my machine.

--
Joe


