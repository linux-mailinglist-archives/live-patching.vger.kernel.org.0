Return-Path: <live-patching+bounces-2100-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEbXKIxFpmlyNQAAu9opvQ
	(envelope-from <live-patching+bounces-2100-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:21:00 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFD81E7F52
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC3A3306BC14
	for <lists+live-patching@lfdr.de>; Tue,  3 Mar 2026 02:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1C4373C19;
	Tue,  3 Mar 2026 02:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFq1pvwX"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15F730C34A
	for <live-patching@vger.kernel.org>; Tue,  3 Mar 2026 02:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504452; cv=none; b=DQdmIameSRV/EO3RV32sYkPEgU42aEd6tS3ctJa2MsH1Y0L4pGejTN3nm2HwkXYkd2lAnKMs/6mXTiOkLSGTTQD6vbXoO1lJgwGxxVhvFzfMW6xHQQJpJz43j7c2A4ptYbosFtkJHLncmc2nF+D7GbZkQ+w0oWYkJAsKlO5PHrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504452; c=relaxed/simple;
	bh=zcbO+OORas/v5OmTPl2IpSIhGVS0qfKBCjubOan5xMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSD9bIdfR7iIfpxCOe1T5SIQ7kUSGAfEJM7dQtv6Tv/ogfvG329E9GInE3cILPC3lExTBfzm0d19N4WnlMIeOySoDSVJjNKUKhGuNSORGN0VrNP/xrXaDuZ7Oq0vQXu7cHKtDoQvRh5ArRsgO19vdxK12AisKnPrDP+KNXmj2YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RFq1pvwX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772504450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rpv8yO1Ck+YjshUVFO+73J4zai+Lp6Tloogb3UGfUbE=;
	b=RFq1pvwXNAyoBbLRrxfZZqs5l8XKRksaBWOnSGSSt/aLCy1Itm4MBcNuySYcT8hYQZBd8e
	Q2iZ+6NzfQhyVAYVYTpT5OcPgj4zm42XaYvkWxMi9uNUJif8JwaoklrVOrCHqA+KghFObR
	WXdc7cuBq/jmfLMiBjiP2s404i7xuz0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-6i09qu3aMrmCuTMAYJd57Q-1; Mon,
 02 Mar 2026 21:20:47 -0500
X-MC-Unique: 6i09qu3aMrmCuTMAYJd57Q-1
X-Mimecast-MFC-AGG-ID: 6i09qu3aMrmCuTMAYJd57Q_1772504446
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51B351800378;
	Tue,  3 Mar 2026 02:20:46 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C27BB1800370;
	Tue,  3 Mar 2026 02:20:44 +0000 (UTC)
Date: Mon, 2 Mar 2026 21:20:41 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 10/13] livepatch/klp-build: provide friendlier error
 messages
Message-ID: <aaZFeVWhiBh0-Hga@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-11-joe.lawrence@redhat.com>
 <g27qxnginju67wz2eqhfy4mnaerydaw5mh3tbtlb5zo5pj5unu@th5y2kq7xokf>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g27qxnginju67wz2eqhfy4mnaerydaw5mh3tbtlb5zo5pj5unu@th5y2kq7xokf>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 0EFD81E7F52
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2100-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 01:15:55PM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 17, 2026 at 11:06:41AM -0500, Joe Lawrence wrote:
> > Provide more context for common klp-build failure modes.  Clarify which
> > user-provided patch is unsupported or failed to apply, and explicitly
> > identify which kernel build (original or patched) failed.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  scripts/livepatch/klp-build | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index 6d3adadfc394..80703ec4d775 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -351,7 +351,7 @@ check_unsupported_patches() {
> >  		for file in "${files[@]}"; do
> >  			case "$file" in
> >  				lib/*|*.S)
> > -					die "unsupported patch to $file"
> > +					die "$patch unsupported patch to $file"
> 
> Can we add a colon here, like
> 
>   foo.patch: unsupported patch to bar.c
> 

Good idea, will do in v4.

--
Joe


