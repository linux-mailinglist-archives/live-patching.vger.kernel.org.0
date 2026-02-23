Return-Path: <live-patching+bounces-2072-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id K0gWMV/HnGkwKQQAu9opvQ
	(envelope-from <live-patching+bounces-2072-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:32:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 113A817D9AC
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 454A5303DADE
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 21:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9485C378808;
	Mon, 23 Feb 2026 21:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0wMnVxk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719DF36CDE3
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 21:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771882332; cv=none; b=oXrlXqsXek8K5K3EHaG1zIIy+lzOfkv2b2atF4MVo5Db4IkZeNnlsTtva3MbdN0iA2c5832ql/pFY8ssacreHNnNtho3ImOHDngcyM44TjGgEYQvwqEG3/pO2gAyKfwZQoenRMqWmZU0vrtUlvJTnkTzE6y85MdoutOcK+we5XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771882332; c=relaxed/simple;
	bh=Q9BmQ+EEAtNFmGKno5/ZywermgmltXznMKRaijNLyH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STne4FVNsh4li2i7sB1cZqJFsLCz3KFHOyYtRELciJW2pIaeiO4Roh/mHlphu/Pmm/1R6tduBW43jkseSS4ziRomDxWyX33R0wyZIHuV6IvUKLpTfrWlhWFSlKwlBAaP2tErrF5bt3iFzmG5UTTpb9D2HC55MiNGR6Aua+3XWMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0wMnVxk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A83C116C6;
	Mon, 23 Feb 2026 21:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771882332;
	bh=Q9BmQ+EEAtNFmGKno5/ZywermgmltXznMKRaijNLyH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n0wMnVxkFZ18ekClMjQDDWe0tx9EPrMd5yYO0tlGkOFbrVXpGBvbQMfza/2UGlaSp
	 bF2ooZ1TiocM5fzgZHyPLUFuZCnYBJa3VT67J9OPf9F1eH9wECJ0PILHNbnahCu+TM
	 yVB/AgS44H6xXcKrRVWRz19Z8+j/w3VARlnQvRubgdKBwac+QzgnQiS/WK8cQTeI+Y
	 D0kacscpOYagdFBY1xdog4z75tJdEL4fk0rkbH+gy2L4aXuOMnbijS2iERMRBSmbQh
	 vDqNRMQhw8sfa85TqcvrJyD1AodvgrFMRyL7vs/lJUdBF29zvTXOfZuT1eBGBsDRfM
	 cOWfAHCXaXUuQ==
Date: Mon, 23 Feb 2026 13:32:09 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 11/13] livepatch/klp-build: add terminal color output
Message-ID: <oetssfso7zbcsleiapmqwfiwqcobu3ghsf26ubxbqnkild7dve@hpa3e45rgtp7>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-12-joe.lawrence@redhat.com>
 <7lykwpkqigzixza3xqhg7yqfhydcdim6dmzf2e5lembxjim6zb@z6y5n6qpb4xs>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7lykwpkqigzixza3xqhg7yqfhydcdim6dmzf2e5lembxjim6zb@z6y5n6qpb4xs>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2072-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 113A817D9AC
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 01:28:45PM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 17, 2026 at 11:06:42AM -0500, Joe Lawrence wrote:
> > Improve the readability of klp-build output by implementing a basic
> > color scheme.  When the standard output and error are connected to a
> > terminal, highlight status messages in bold, warnings in yellow, and
> > errors in red.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  scripts/livepatch/klp-build | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index 80703ec4d775..fd104ace29e6 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -52,6 +52,15 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
> >  
> >  KLP_DIFF_LOG="$DIFF_DIR/diff.log"
> >  
> > +# Terminal output colors
> > +read -r COLOR_RESET COLOR_BOLD COLOR_ERROR COLOR_WARN <<< ""
> > +if [[ -t 1 && -t 2 ]]; then
> > +	COLOR_RESET="\033[0m"
> > +	COLOR_BOLD="\033[1m"
> > +	COLOR_ERROR="\033[0;31m"
> > +	COLOR_WARN="\033[0;33m"
> > +fi
> > +
> >  grep0() {
> >  	# shellcheck disable=SC2317
> >  	command grep "$@" || true
> > @@ -65,15 +74,15 @@ grep() {
> >  }
> >  
> >  status() {
> > -	echo "$*"
> > +	echo -e "${COLOR_BOLD}$*${COLOR_RESET}"
> >  }
> >  
> >  warn() {
> > -	echo "error: $SCRIPT: $*" >&2
> > +	echo -e "${COLOR_WARN}warn${COLOR_RESET}: $SCRIPT: $*" >&2
> 
> Shouldn't this reset the colors *after* printing out the whole message?
> 
> Also, while it does make sense for warn() to print "warn:" rather than
> "error:", note its called by trap_err(), which should print the latter.

also I think s/warn:/warning:/ is better.

-- 
Josh

