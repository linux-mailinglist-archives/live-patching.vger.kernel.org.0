Return-Path: <live-patching+bounces-2000-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMBqF/uci2k3XAAAu9opvQ
	(envelope-from <live-patching+bounces-2000-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:02:51 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B089811F3CC
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DDA73006160
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 20:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3DB33344D;
	Tue, 10 Feb 2026 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYQ5jHz8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C89E329E5A
	for <live-patching@vger.kernel.org>; Tue, 10 Feb 2026 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770757076; cv=none; b=Ci3VJdxrTW7m6r9/PnY8FqI5MmS4F5VirC63if9T/Lb4qdRIfoEX5v8J4+/hV47aom1kfjpJI11UeQ6iqhhjIceoLRefJLClShvbNY/zLJs7r1BElRzANy+UrMgA2pQkcTf/YCLEBTjcvQXfxCUPaliJ/46h/usWBw7AM8CloL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770757076; c=relaxed/simple;
	bh=GHUYWxB3ytWz+Jq/yK18G/VooHjVH3n1x1Bvsk9cgkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlfTLlHbPYxj9J+MieSgqj1hj2AdcFDPCaA7ASvx+6Lb6iGARiNBtKJy+aTPl1EKsPEknp57ljG/DihK1TTY5vI9V4WwnXBvyLVXa4dDTdgZt60gCmzdWK5iAozmP0y5VShXlnm9dgdoJe1P29IJ9/tdYdDfjuoH7DjAGN2lJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYQ5jHz8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EFEC116C6;
	Tue, 10 Feb 2026 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770757076;
	bh=GHUYWxB3ytWz+Jq/yK18G/VooHjVH3n1x1Bvsk9cgkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kYQ5jHz8NA27DnXglPxGECeReDJX9h8uBPv906iPawr6W7CobHyy4o9taLphF3LH+
	 wMAIsFqm4ByGZjolXE3DllAqmx6VABfJaAygDLJcl2iWjg6gm7tEpoGeRqhYC2CBk6
	 UisgBXLEzPWyeO1UmHBYd8TIbQ2lMLwQrIjOnhSdg8ThEmoweZ8xFaBFFeDeIteBiz
	 JxZ3ziljCXDPGWttESCiRXe5/BQDlsIUrHx0s5jbJFvT42PsDQggF+uGkeBecztJl+
	 KhpGrDTGkvtDi8s70V6NnvzwMTcWGqNy1eLgUBThJj418inXuy6RcX8LYjKCNbJHnu
	 wyon9g0KmBG9g==
Date: Tue, 10 Feb 2026 12:57:53 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 2/5] livepatch/klp-build: handle patches that
 add/remove files
Message-ID: <7xszgbtfrc7c2ktsc7sytaeu5qljwxryhjhujdar2sin2ibp6c@o242qtwztl27>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-3-joe.lawrence@redhat.com>
 <ywooax5vfkh7k7h4mjpxfhtbkr3rdcvi5sjqmnjgcmxrc4ykwa@mk6z5zosbuvz>
 <aYTGtI41jhDSm5gf@redhat.com>
 <uy6a5xdp7e6cp6xj2r5zavb2ujtkapsjp2hixtgga4vwywkslv@6uhrgvb2hvo3>
 <aYuNEwWoByiw0KDc@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYuNEwWoByiw0KDc@redhat.com>
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
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2000-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B089811F3CC
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 02:54:59PM -0500, Joe Lawrence wrote:
> On Thu, Feb 05, 2026 at 08:53:42AM -0800, Josh Poimboeuf wrote:
> > On Thu, Feb 05, 2026 at 11:35:00AM -0500, Joe Lawrence wrote:
> > > On Wed, Feb 04, 2026 at 10:02:38AM -0800, Josh Poimboeuf wrote:
> > > > On Tue, Feb 03, 2026 at 09:51:37PM -0500, Joe Lawrence wrote:
> > > > > The klp-build script prepares a clean patch by populating two temporary
> > > > > directories ('a' and 'b') with source files and diffing the result.
> > > > > However, this process currently fails when a patch introduces a new
> > > > > source file as the script attempts to copy files that do not yet exist
> > > > > in the original source tree.  Likewise, there is a similar limitation
> > > > > when a patch removes a source file and the script tries to copy files
> > > > > that no longer exist.
> > > > > 
> > > > > Refactor the file-gathering logic to distinguish between original input
> > > > > files and patched output files:
> > > > > 
> > > > > - Split get_patch_files() into get_patch_input_files() and
> > > > >   get_patch_output_files() to identify which files exist before and
> > > > >   after patch application.
> > > > > - Filter out "/dev/null" from both to handle file creation/deletion
> > > > > - Update refresh_patch() to only copy existing input files to the 'a'
> > > > >   directory and the resulting output files to the 'b' directory.
> > > > > 
> > > > > This allows klp-build to successfully process patches that add or remove
> > > > > source files.
> > > > > 
> > > > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > > > ---
> > > > >  scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
> > > > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > > > > 
> > > > > Lightly tested with patches that added or removed a source file, as
> > > > > generated by `git diff`, `git format-patch`, and `diff -Nupr`.
> > > > > 
> > > > > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > > > > index 9f1b77c2b2b7..5a99ff4c4729 100755
> > > > > --- a/scripts/livepatch/klp-build
> > > > > +++ b/scripts/livepatch/klp-build
> > > > > @@ -299,15 +299,33 @@ set_kernelversion() {
> > > > >  	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
> > > > >  }
> > > > >  
> > > > > -get_patch_files() {
> > > > > +get_patch_input_files() {
> > > > > +	local patch="$1"
> > > > > +
> > > > > +	grep0 -E '^--- ' "$patch"				\
> > > > > +		| gawk '{print $2}'				\
> > > > > +		| grep -v '^/dev/null$'				\
> > > > 
> > > > Because pipefail is enabled, the grep0 helper should be used instead of
> > > > grep, otherwise a failed match can propagate to an error.  Maybe we need
> > > > a "make check" or something which enforces that and runs shellcheck.
> > > > 
> 
> How about defining our own grep in the script that intercepts the call
> and throws an error:
> 
>   grep() {
>   	echo "error: $SCRIPT: use grep0 or 'command grep' instead of bare grep" >&2
>   	exit 1
>   }
> 
> That seems easier than trying to externally parse the script to figure
> out what's a command, comment, word-match, legit grep, etc.

Ack, sounds good.

-- 
Josh

