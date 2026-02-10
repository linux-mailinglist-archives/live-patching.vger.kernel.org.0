Return-Path: <live-patching+bounces-1999-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFzCIh6Ni2kTWAAAu9opvQ
	(envelope-from <live-patching+bounces-1999-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 20:55:10 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FAA11ECFF
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 20:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51DA23032F70
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 19:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1DF303A3B;
	Tue, 10 Feb 2026 19:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J4GVuXfu"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978C22C11EF
	for <live-patching@vger.kernel.org>; Tue, 10 Feb 2026 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770753307; cv=none; b=hZLzfFf999vy5+G6n2tdv6iV4ts2G92xH3JYZAK7osbeiTtZ1Bp3EUki8B1wi/zxWluCOBlKQTyESlruut7F94/DBDgfPxjN6ZxnF+Plu+HBksdukZYORJ5wgMlzxeQ2MGZOX5wn+q767yCWbk2mGhxatfcuqRnkj3G4J0gaueE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770753307; c=relaxed/simple;
	bh=EGxMxoPNvrUNpRC/6FMfR9H4QxsAUEsRqxqtXtMNBuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jOx+QI9P/3de5EMAJBZv9lbrp6t0hj/QvsouZtu29uv7s9lx5ETo0WZCO5ObOUMF2MwjF+X6xcur1QvMuyGPHfYpSQBCLPHcUWL5m2DmrlRwJ6uKvHB9KlUvEA9Jh4K3FPIThHFVecil2mu0hTUhbFjlRvihxAZd1B3hLY+H1Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J4GVuXfu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770753305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCBT2zHhHiDNW3x/PQ0QjsLU+CGvp4enWsmAQ5xdZAM=;
	b=J4GVuXfuf1U1PT0GQ8XeMxr5uKblgUIccwV/RYT6tSvTsAwL9IyhR54ZKLI33A8gmxOxnx
	4jhlNcya1xd+XtoqgAwcvjQKNsAjSErLJY/dc2SdUR5eqSLLAG4E6IN01Dj6Sz+fJgzcCn
	ZIzugPj8MYrE3K0zM4/oCI5O/DIwtGs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-hKKf8UFPNsmo9j0sZJZEEw-1; Tue,
 10 Feb 2026 14:55:04 -0500
X-MC-Unique: hKKf8UFPNsmo9j0sZJZEEw-1
X-Mimecast-MFC-AGG-ID: hKKf8UFPNsmo9j0sZJZEEw_1770753303
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D85791800349;
	Tue, 10 Feb 2026 19:55:02 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.37])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9028630001BF;
	Tue, 10 Feb 2026 19:55:01 +0000 (UTC)
Date: Tue, 10 Feb 2026 14:54:59 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 2/5] livepatch/klp-build: handle patches that
 add/remove files
Message-ID: <aYuNEwWoByiw0KDc@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-3-joe.lawrence@redhat.com>
 <ywooax5vfkh7k7h4mjpxfhtbkr3rdcvi5sjqmnjgcmxrc4ykwa@mk6z5zosbuvz>
 <aYTGtI41jhDSm5gf@redhat.com>
 <uy6a5xdp7e6cp6xj2r5zavb2ujtkapsjp2hixtgga4vwywkslv@6uhrgvb2hvo3>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uy6a5xdp7e6cp6xj2r5zavb2ujtkapsjp2hixtgga4vwywkslv@6uhrgvb2hvo3>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1999-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E4FAA11ECFF
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 08:53:42AM -0800, Josh Poimboeuf wrote:
> On Thu, Feb 05, 2026 at 11:35:00AM -0500, Joe Lawrence wrote:
> > On Wed, Feb 04, 2026 at 10:02:38AM -0800, Josh Poimboeuf wrote:
> > > On Tue, Feb 03, 2026 at 09:51:37PM -0500, Joe Lawrence wrote:
> > > > The klp-build script prepares a clean patch by populating two temporary
> > > > directories ('a' and 'b') with source files and diffing the result.
> > > > However, this process currently fails when a patch introduces a new
> > > > source file as the script attempts to copy files that do not yet exist
> > > > in the original source tree.  Likewise, there is a similar limitation
> > > > when a patch removes a source file and the script tries to copy files
> > > > that no longer exist.
> > > > 
> > > > Refactor the file-gathering logic to distinguish between original input
> > > > files and patched output files:
> > > > 
> > > > - Split get_patch_files() into get_patch_input_files() and
> > > >   get_patch_output_files() to identify which files exist before and
> > > >   after patch application.
> > > > - Filter out "/dev/null" from both to handle file creation/deletion
> > > > - Update refresh_patch() to only copy existing input files to the 'a'
> > > >   directory and the resulting output files to the 'b' directory.
> > > > 
> > > > This allows klp-build to successfully process patches that add or remove
> > > > source files.
> > > > 
> > > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > > ---
> > > >  scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
> > > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > > > 
> > > > Lightly tested with patches that added or removed a source file, as
> > > > generated by `git diff`, `git format-patch`, and `diff -Nupr`.
> > > > 
> > > > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > > > index 9f1b77c2b2b7..5a99ff4c4729 100755
> > > > --- a/scripts/livepatch/klp-build
> > > > +++ b/scripts/livepatch/klp-build
> > > > @@ -299,15 +299,33 @@ set_kernelversion() {
> > > >  	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
> > > >  }
> > > >  
> > > > -get_patch_files() {
> > > > +get_patch_input_files() {
> > > > +	local patch="$1"
> > > > +
> > > > +	grep0 -E '^--- ' "$patch"				\
> > > > +		| gawk '{print $2}'				\
> > > > +		| grep -v '^/dev/null$'				\
> > > 
> > > Because pipefail is enabled, the grep0 helper should be used instead of
> > > grep, otherwise a failed match can propagate to an error.  Maybe we need
> > > a "make check" or something which enforces that and runs shellcheck.
> > > 

How about defining our own grep in the script that intercepts the call
and throws an error:

  grep() {
  	echo "error: $SCRIPT: use grep0 or 'command grep' instead of bare grep" >&2
  	exit 1
  }

That seems easier than trying to externally parse the script to figure
out what's a command, comment, word-match, legit grep, etc.

--
Joe


