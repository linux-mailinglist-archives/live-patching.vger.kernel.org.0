Return-Path: <live-patching+bounces-1994-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GM4EOILThGmf5gMAu9opvQ
	(envelope-from <live-patching+bounces-1994-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 18:29:38 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D00BF5F12
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 18:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A57C3014123
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 17:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780EC31B10D;
	Thu,  5 Feb 2026 17:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XF1SqrA2"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460119B5A3
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770312461; cv=none; b=nJDHT0MNZMmaW0nB2ChuYhXjsWm2eDDaTH/+2kEFqeYWc21oLOoyLANmoyGkqlN4mll4rVz+DtFF04o20GS5e+CpVGgf+XCg8KkgeriEAVDgtjImUYinD2YzV6gpm8bg3oFqQhxFi6kXOWAEHYRN8gMjFGdVOYTV6HimZ0j1ulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770312461; c=relaxed/simple;
	bh=ZO/zXa4ZebmQRBkK2raZjxTYiIkHp3jaf5E+XMwT14g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZh9emx2IQKJ7mGTlghOWHA9ZhJAP1qz0J4UZncGXNZl80qgAo4nJ0uOpC4AkF82pYAaFjPvEQaX8VbsnuM3tstFwaA/YUrG55L6mxTOtrMTCy+LO4jfRBP1nAsKLWX6bzGFwld34y96PzmImRcM6saxTcBg/gAl/Ff1kDO7nf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XF1SqrA2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770312460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TBIrGOtl0+4HCUarhG5DdvyzNFLEFddz2v+V/O2N1oA=;
	b=XF1SqrA2RvkzeLoeUVarmozC3F6ah6eVlSCRaO9jY39OqAhi+nkAnm5l3Mk0NDuOqa8iBH
	WBLPFtrzCr59GSfS892g1+i8S1smWntX7d4jvv8gla4iyYeqn0FvwL3ymrKXr6NwlcxBlk
	PBQ5SBTw44mx1YJIpX7eph8orZav2zs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-472-VxhNYfUzMv21ZSM58fJBnw-1; Thu,
 05 Feb 2026 12:27:35 -0500
X-MC-Unique: VxhNYfUzMv21ZSM58fJBnw-1
X-Mimecast-MFC-AGG-ID: VxhNYfUzMv21ZSM58fJBnw_1770312452
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BAB8187B997;
	Thu,  5 Feb 2026 17:27:29 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.42])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2772519560B5;
	Thu,  5 Feb 2026 17:27:27 +0000 (UTC)
Date: Thu, 5 Feb 2026 12:27:25 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 3/5] livepatch/klp-build: switch to GNU patch and
 recountdiff
Message-ID: <aYTS_ZtgcnZP3UCm@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-4-joe.lawrence@redhat.com>
 <2j5d3dwa6jymmnte4gcykbm5pfzc36x7onn2ojgjliwkxnlcik@34hti52xld5m>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2j5d3dwa6jymmnte4gcykbm5pfzc36x7onn2ojgjliwkxnlcik@34hti52xld5m>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1994-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3D00BF5F12
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 10:35:07AM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 03, 2026 at 09:51:38PM -0500, Joe Lawrence wrote:
> > I think this does simplify things, but:
> > 
> >   - introduces a dependency on patchutil's recountdiff
> 
> I was wondering if we could instead just update fix-patch-lines to fix
> the line numbers/counts, but I get the feeling that would require
> rewriting the whole script and may not be worth the complexity.  That
> script is nice and simple and robust at the moment.
> 

Ok, I'll take a look at fix-patch-lines and see how complicated it might
turn out to incorporate a recount.

> >   - requires goofy epoch timestamp filtering as `diff -N` doesn't use
> >     the `git diff` /dev/null, but a localized beginining of time epoch
> >     that may be 1969 or 1970 depending on the local timezone
> >   - can be *really* chatty, for example:
> > 
> >   Validating patch(es)
> >   patching file fs/proc/cmdline.c
> >   Hunk #1 succeeded at 7 (offset 1 line).
> >   Fixing patch(es)
> >   patching file fs/proc/cmdline.c
> >   Hunk #1 succeeded at 7 (offset 1 line).
> >   patching file fs/proc/cmdline.c
> >   patching file fs/proc/cmdline.c
> >   Building patched kernel
> >   Copying patched object files
> >   Diffing objects
> >   vmlinux.o: changed function: override_release
> >   vmlinux.o: changed function: cmdline_proc_show
> >   Building patch module: livepatch-cmdline-string.ko
> >   SUCCESS
> > 
> >   My initial thought was that I'd only be interested in knowing about
> >   patch offset/fuzz during the validation phase.  And in the interest of
> >   clarifying some of the output messages, it would be nice to know the
> >   patch it was referring to, so how about a follow up patch
> >   pretty-formatting with some indentation like:
> > 
> >   Validating patch(es)
> >     cmdline-string.patch
> >       patching file fs/proc/cmdline.c
> >       Hunk #1 succeeded at 7 (offset 1 line).
> >   Fixing patch(es)
> >   Building patched kernel
> >   Copying patched object files
> >   Diffing objects
> >   vmlinux.o: changed function: override_release
> >   vmlinux.o: changed function: cmdline_proc_show
> >   Building patch module: livepatch-cmdline-string.ko
> >   SUCCESS
> > 
> >   That said, Song suggested using --silent across the board, so maybe
> >   tie that into the existing --verbose option?
> 
> Hm.  Currently we go to considerable effort to make klp-build's output
> as concise as possible, which is good.  On the other hand, it might be
> important to know the patch has fuzz.
> 

To keep it succinct, the script could check for offset/fuzz and only
report it, including the "patching file ..." part, if there is any.

> I'm thinking I would agree that maybe it should be verbose when
> validating patches and silent elsewhere.  And the pretty formatting is a
> nice upgrade to that.
> 

In the past I've used a little function like:

  indent() {
      local num="${1:-0}"
      sed "s/^/$(printf '%*s' "$num" '')/"
  }

so I could just pipe in echo or command output like: `./cmd | indent 2`.
Good enough or maybe you have one?

> We might also consider indenting the outputs of the other steps.  For
> example:
> 
>   Building patched kernel
>     vmlinux.o: some warning
>   Copying patched object files
>   Diffing objects
>     vmlinux.o: changed function: override_release
>     vmlinux.o: changed function: cmdline_proc_show
> 
> Or alternatively, print the step names in ASCII bold or something.
> 

While I do kinda like the recent color coded output from the compilers,
I don't know if I'm ready for a full-color livepatch build experience :D

I wouldn't be against it, but my vote leans towards the indentation
since it leaves prettier log files, even if the color codes are filtered
out.  Then again, the color scheme bikeshedding we could look forward
to!

> >  apply_patch() {
> >  	local patch="$1"
> > -	shift
> > -	local extra_args=("$@")
> >  
> >  	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
> >  
> >  	(
> >  		cd "$SRC"
> > -
> > -		# The sed strips the version signature from 'git format-patch',
> > -		# otherwise 'git apply --recount' warns.
> > -		sed -n '/^-- /q;p' "$patch" |
> > -			git apply "${extra_args[@]}"
> > +		# The sed strips the version signature from 'git format-patch'.
> > +		sed -n '/^-- /q;p' "$patch" | \
> > +			patch -p1 --no-backup-if-mismatch -r /dev/null
> 
> Is this still needed now that we don't use git apply --recount?
> 

I'll double check.  I recall having difficulties with recountdiff when
taking these out, but can't reproduce that by hand at the moment.

> > @@ -490,7 +468,7 @@ fix_patches() {
> >  
> >  		cp -f "$old_patch" "$tmp_patch"
> >  		refresh_patch "$tmp_patch"
> > -		"$FIX_PATCH_LINES" "$tmp_patch" > "$new_patch"
> > +		"$FIX_PATCH_LINES" "$tmp_patch" | recountdiff > "$new_patch"
> >  		refresh_patch "$new_patch"
> 
> Do we still need to refresh after the recountdiff?
> 

Yeah I think it's redundant as long as recountdiff doesn't emit
something weird, but if it did, it's probably already screwed up the
patch.

--
Joe


