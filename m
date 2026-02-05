Return-Path: <live-patching+bounces-1991-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIuKGa/HhGk45QMAu9opvQ
	(envelope-from <live-patching+bounces-1991-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 17:39:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B34D4F5528
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 17:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D905304E732
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 16:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E87F438FFF;
	Thu,  5 Feb 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aKTSuQqw"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD493EFD26
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770309309; cv=none; b=D8Fri0LixQZVPIcTpZ3wnTyD7mBlUIJaou/5nkxQdjCumHG8VKk4sdyKVOq3fCEQoHoNco7G37i87VVgr1xj2NHort/EykWUW28iG8AXjNaDp+aQjteMqn4KuyUoa5hkhe8aaYtG/mRhBwycJIN9o0yeJqqJD3bbHyOZZKCtxIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770309309; c=relaxed/simple;
	bh=sBiMYD3QP2uokG5ycRG4iRETsIvbdP05BXTWXjdIwCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaX+9mX0FpvGXIJmp1nlnfZspFGrobk2bdtulr6Bmb9GtcnHZL3ZuSaZi6CZIuABlwRd3vhflwdK947o6lUvEzFAcX4UJ2FKN1HlqxqlsDrN1+xKMQeFNMH8coQleEepz0YQwXbB0DyDs+cHABDO2RjkNwrWVYrH3zkXjdfedWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aKTSuQqw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770309308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xToehjWmPt+ZPuFSA5rHP3YztVroLUrG0HlMBYNpD2U=;
	b=aKTSuQqwG0C8gtCwbACOxzvLL7rboWpx46CBiS/cbCf/HdrfqB/6yS8DqigIQn3jQfNqWd
	qr7j7mlmGq5r7nmh3SCJMxxllmqEJBk//25cFHopjfoM2BhYaSJRSU3eDEs9KV/bPPpAPj
	xAzpQEgoRkqFYoz2644lDM4Dg0SHdJM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-E07EBiOKPtuwrzqxYdBAaw-1; Thu,
 05 Feb 2026 11:35:05 -0500
X-MC-Unique: E07EBiOKPtuwrzqxYdBAaw-1
X-Mimecast-MFC-AGG-ID: E07EBiOKPtuwrzqxYdBAaw_1770309303
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0219195605C;
	Thu,  5 Feb 2026 16:35:03 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A730918003F5;
	Thu,  5 Feb 2026 16:35:02 +0000 (UTC)
Date: Thu, 5 Feb 2026 11:35:00 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 2/5] livepatch/klp-build: handle patches that
 add/remove files
Message-ID: <aYTGtI41jhDSm5gf@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-3-joe.lawrence@redhat.com>
 <ywooax5vfkh7k7h4mjpxfhtbkr3rdcvi5sjqmnjgcmxrc4ykwa@mk6z5zosbuvz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ywooax5vfkh7k7h4mjpxfhtbkr3rdcvi5sjqmnjgcmxrc4ykwa@mk6z5zosbuvz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1991-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B34D4F5528
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 10:02:38AM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 03, 2026 at 09:51:37PM -0500, Joe Lawrence wrote:
> > The klp-build script prepares a clean patch by populating two temporary
> > directories ('a' and 'b') with source files and diffing the result.
> > However, this process currently fails when a patch introduces a new
> > source file as the script attempts to copy files that do not yet exist
> > in the original source tree.  Likewise, there is a similar limitation
> > when a patch removes a source file and the script tries to copy files
> > that no longer exist.
> > 
> > Refactor the file-gathering logic to distinguish between original input
> > files and patched output files:
> > 
> > - Split get_patch_files() into get_patch_input_files() and
> >   get_patch_output_files() to identify which files exist before and
> >   after patch application.
> > - Filter out "/dev/null" from both to handle file creation/deletion
> > - Update refresh_patch() to only copy existing input files to the 'a'
> >   directory and the resulting output files to the 'b' directory.
> > 
> > This allows klp-build to successfully process patches that add or remove
> > source files.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
> >  1 file changed, 27 insertions(+), 7 deletions(-)
> > 
> > Lightly tested with patches that added or removed a source file, as
> > generated by `git diff`, `git format-patch`, and `diff -Nupr`.
> > 
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index 9f1b77c2b2b7..5a99ff4c4729 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -299,15 +299,33 @@ set_kernelversion() {
> >  	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
> >  }
> >  
> > -get_patch_files() {
> > +get_patch_input_files() {
> > +	local patch="$1"
> > +
> > +	grep0 -E '^--- ' "$patch"				\
> > +		| gawk '{print $2}'				\
> > +		| grep -v '^/dev/null$'				\
> 
> Because pipefail is enabled, the grep0 helper should be used instead of
> grep, otherwise a failed match can propagate to an error.  Maybe we need
> a "make check" or something which enforces that and runs shellcheck.
> 

Good catch.  So your idea is to drop a Makefile in scripts/livepatch
with a check target that runs shellcheck and then a klp-build specific
check for any non-grep0 grep?  (like `grep -w 'grep' klp-build`).  If
so, any other things to should check for?

--
Joe


