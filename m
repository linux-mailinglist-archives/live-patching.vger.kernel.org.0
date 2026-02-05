Return-Path: <live-patching+bounces-1993-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Oa/B1TMhGk45QMAu9opvQ
	(envelope-from <live-patching+bounces-1993-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 17:59:00 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77172F5941
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 17:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61B8130715FA
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 16:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB6343637F;
	Thu,  5 Feb 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NNMkes6p"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ED42DCF45
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310424; cv=none; b=tr+wdZbKigMFCHh/sGEAfKVcDoHUKOnM4pBWCYUFIZWrRNy06nUEmvME1XBLJaKQmY+y7o9eSgm6f8XZfyxikC/29PEo9T6d9Mq3bFE16Gtle+x2FbmprN26DUO4zCyvHBoHbOCOIDHkyox7tgJ1LVAFy7OfS7KbFCfUVHV9A/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310424; c=relaxed/simple;
	bh=I8ND0B+SUt+6LEITR69+ACNctaYWJ7w5vZPTv13lDxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBAdrDug+QBPF2hqVtShnagimIL3pm2rM86moh1ZsactVQx5HWcRNjwtnU4Zw4tPM59mLJyJvwXB5ehnZb9Ykr1G7gQtq3Yk/u/Z7jvWuvruJu1Sho7oqcUd6xcR/3uGZzMyw1xPgcEVC+MbsRnVYQslp1q4vS31R+KaJDMf06U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NNMkes6p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB6C4CEF7;
	Thu,  5 Feb 2026 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770310424;
	bh=I8ND0B+SUt+6LEITR69+ACNctaYWJ7w5vZPTv13lDxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NNMkes6ppTWltS1CGoXKY+gOrThpG2w1jg5jIRhzHX8lqud8ZHUnvQMZDvjYy8ikl
	 pEjVgzTB2HHS73caYjkY4EpWRxTGJIfsEISoZ/ynXKUxH4qpYTzSEYlWyi/HemqMaa
	 sDGhgqn5NsWrUo9Bk/PKw0eCaWwrAYiQDsojo3W3+tGsTUgFQwI6VuSaVgtfl0fCuA
	 BlFqsB50HHVcwJdnk1SLOomdbBQ6yI5III//rXrqgclo5VVsQMEIau1mzB6+hwUVbE
	 qD+DYUh6F4RJgLpNaU7UzuZuUq1Oon5HHoqg8qVn3hRFuPHmeUxYGA6xQ+IDMlOGzz
	 GfpSy/5yTs6WQ==
Date: Thu, 5 Feb 2026 08:53:42 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 2/5] livepatch/klp-build: handle patches that
 add/remove files
Message-ID: <uy6a5xdp7e6cp6xj2r5zavb2ujtkapsjp2hixtgga4vwywkslv@6uhrgvb2hvo3>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-3-joe.lawrence@redhat.com>
 <ywooax5vfkh7k7h4mjpxfhtbkr3rdcvi5sjqmnjgcmxrc4ykwa@mk6z5zosbuvz>
 <aYTGtI41jhDSm5gf@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYTGtI41jhDSm5gf@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1993-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 77172F5941
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 11:35:00AM -0500, Joe Lawrence wrote:
> On Wed, Feb 04, 2026 at 10:02:38AM -0800, Josh Poimboeuf wrote:
> > On Tue, Feb 03, 2026 at 09:51:37PM -0500, Joe Lawrence wrote:
> > > The klp-build script prepares a clean patch by populating two temporary
> > > directories ('a' and 'b') with source files and diffing the result.
> > > However, this process currently fails when a patch introduces a new
> > > source file as the script attempts to copy files that do not yet exist
> > > in the original source tree.  Likewise, there is a similar limitation
> > > when a patch removes a source file and the script tries to copy files
> > > that no longer exist.
> > > 
> > > Refactor the file-gathering logic to distinguish between original input
> > > files and patched output files:
> > > 
> > > - Split get_patch_files() into get_patch_input_files() and
> > >   get_patch_output_files() to identify which files exist before and
> > >   after patch application.
> > > - Filter out "/dev/null" from both to handle file creation/deletion
> > > - Update refresh_patch() to only copy existing input files to the 'a'
> > >   directory and the resulting output files to the 'b' directory.
> > > 
> > > This allows klp-build to successfully process patches that add or remove
> > > source files.
> > > 
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > ---
> > >  scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
> > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > > 
> > > Lightly tested with patches that added or removed a source file, as
> > > generated by `git diff`, `git format-patch`, and `diff -Nupr`.
> > > 
> > > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > > index 9f1b77c2b2b7..5a99ff4c4729 100755
> > > --- a/scripts/livepatch/klp-build
> > > +++ b/scripts/livepatch/klp-build
> > > @@ -299,15 +299,33 @@ set_kernelversion() {
> > >  	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
> > >  }
> > >  
> > > -get_patch_files() {
> > > +get_patch_input_files() {
> > > +	local patch="$1"
> > > +
> > > +	grep0 -E '^--- ' "$patch"				\
> > > +		| gawk '{print $2}'				\
> > > +		| grep -v '^/dev/null$'				\
> > 
> > Because pipefail is enabled, the grep0 helper should be used instead of
> > grep, otherwise a failed match can propagate to an error.  Maybe we need
> > a "make check" or something which enforces that and runs shellcheck.
> > 
> 
> Good catch.  So your idea is to drop a Makefile in scripts/livepatch
> with a check target that runs shellcheck and then a klp-build specific
> check for any non-grep0 grep?  (like `grep -w 'grep' klp-build`).  If
> so, any other things to should check for?

That's all I can think of, hopefully shellcheck would catch most of the
other footguns.

-- 
Josh

