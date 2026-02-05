Return-Path: <live-patching+bounces-1995-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAf0C2TYhGlo5gMAu9opvQ
	(envelope-from <live-patching+bounces-1995-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 18:50:28 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCB7F62F7
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 18:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC5BE306ABD1
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 17:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1EE2EAB8E;
	Thu,  5 Feb 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMqEcn29"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5522822173D
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313660; cv=none; b=LRNyJHxF7jUUSCMYWKGV8VHqPWhTV+kMHeIWESbQThfGvhQDVlWaBpZVUiuC8vBWfOk4su9g+7OLtBpiPnrG1LmfXifToKAzJU+n500AVEi/7rVgoxSPAepPYPiNM5BKlphKpAl0TphmzR5omFofYofXFOZfhVcB26cRGxPIiqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313660; c=relaxed/simple;
	bh=Fl2vaSq07MFO+nRADmod9dYCvm6gN6cB8DzqNt4dl1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHth3Xzx2PKF2OdKNGfqkC+YCCcTc8WC2ywgxsT/IZS35HCw4D0wt00pqViZGVmFXICMpKYg6LoRAIGvRN/J1yW6Izpx0W+7LmPyTO4TRc7BokTGvJAZ/Td2ydFVSDz35nZWYd/8HKcWZepXgyB6S9NugDUf8ve5kXvSjinTMUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iMqEcn29; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770313659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=icABaNbo+umE/X/XgEhpg8lrLH73l5obiChUXJJ0V1Y=;
	b=iMqEcn29UKoudRwx34oWUqp1Iw1ivUqXwYe07k+51LaxI6F9MwcFaaeNkS8MNcpbRqcVRz
	gEb1ImEfiJuLrPkJ7ovU8lUkiuvvOwjdLHuR42/E1HT2UeD5XUuQ9Z6y1duKMEhuptVLBm
	ZzN5PO1Z34BpocsJOQjC9pFy1jF658w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-IYMd3GqyOzCZQfLTZG63_g-1; Thu,
 05 Feb 2026 12:47:36 -0500
X-MC-Unique: IYMd3GqyOzCZQfLTZG63_g-1
X-Mimecast-MFC-AGG-ID: IYMd3GqyOzCZQfLTZG63_g_1770313654
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B93071956096;
	Thu,  5 Feb 2026 17:47:34 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.42])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49959300DDA1;
	Thu,  5 Feb 2026 17:47:33 +0000 (UTC)
Date: Thu, 5 Feb 2026 12:47:30 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 4/5] livepatch/klp-build: minor short-circuiting tweaks
Message-ID: <aYTXsl4PNljcz9yG@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-5-joe.lawrence@redhat.com>
 <njg3ylqbsk3dc6smj6vnrk2bb7ttjrfsulfzocmh4fsdq527fj@xgoaep6sbqws>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <njg3ylqbsk3dc6smj6vnrk2bb7ttjrfsulfzocmh4fsdq527fj@xgoaep6sbqws>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1995-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BFCB7F62F7
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 10:40:14AM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 03, 2026 at 09:51:39PM -0500, Joe Lawrence wrote:
> > Update SHORT_CIRCUIT behavior to better handle patch validation and
> > argument processing in later klp-build steps.
> > 
> > Perform patch validation for both step 1 (building original kernel)
> > and step 2 (building patched kernel) to ensure patches are verified
> > before any compilation occurs.
> > 
> > Additionally, allow the user to omit input patches when skipping past
> > step 2, while noting that any specified patches will be ignored in that
> > case if they were provided.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  scripts/livepatch/klp-build | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index ee43a9caa107..df3a0fa031a6 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -214,12 +214,18 @@ process_args() {
> >  	done
> >  
> >  	if [[ $# -eq 0 ]]; then
> > -		usage
> > -		exit 1
> > +		if (( SHORT_CIRCUIT <= 2 )); then
> > +			usage
> > +			exit 1
> > +		fi
> 
> Ack
> 
> > +	else
> > +		if (( SHORT_CIRCUIT >= 3 )); then
> > +			status "note: patch arguments ignored at step $SHORT_CIRCUIT"
> > +		fi
> 
> Personally I don't care to see this status, but maybe I'm biased from
> writing the --short-circuit feature and not being confused by this :-)
> 

Alrighty, I'll drop this part unless somebody asks for it.

--
Joe


