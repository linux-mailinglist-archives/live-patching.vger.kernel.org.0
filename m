Return-Path: <live-patching+bounces-2101-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KlhLGtGpmlyNQAAu9opvQ
	(envelope-from <live-patching+bounces-2101-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:24:43 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B695B1E7F9A
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 83555301220B
	for <lists+live-patching@lfdr.de>; Tue,  3 Mar 2026 02:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B863D3750BC;
	Tue,  3 Mar 2026 02:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gT9F8XA0"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76873158535
	for <live-patching@vger.kernel.org>; Tue,  3 Mar 2026 02:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504676; cv=none; b=WtYNEf2lkhQNP5f90VTUtaszp8AbAVKtsMTX+qA8dMK7H1PQSAQllXMNurAr71gprOKUSIbRMu7qCrwiStP1IHDn6fBVAmSyF6fo6H7VyXrhaKy8qKHsLdMnrYi0O6384OEqyqoTNmDi+RZ/2OOuYdxqhWUodeTFe7INShoCPlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504676; c=relaxed/simple;
	bh=grsoeIyS0IOIOlRQ4B4FBG/YcP66KXjyIyYYMh8FmO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwjwRT2nbfs8d3T62+YzM0TCMC9w5jmLFJldEWtRFHHiuVl6ZzYQmaePzHdpGL95bHatBX4ndhBEHeduWBr4bQAdSzlww9gx/T0/lP9cG4j7DCh5sIZv5Vy83eYrdb8G+aQiQkVKrqAy3GWSwEdH2BKHjGH3whE5mCnSAzr50eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gT9F8XA0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772504674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z796Ox5XKXtDyC5cWeuaaD5+SB5/0l/b5WLGLVW4lyU=;
	b=gT9F8XA0zB3h9FcrDeKUCzWtRCIG6ytvCcMvEqjV6h/Op7MnGTu7oS56aL6KzeCFH5tf+y
	yOHBk5FBz8ihm3H+kBBwojettQkpzyjqKbxVUO54qprjusIK7dARFtEKvjyUX55cJwWN6J
	RJ19b7iUd8lCBwgG6Ue6YG5UrjvbOWc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-IxWloyvsN8uvF8KR1cvuTA-1; Mon,
 02 Mar 2026 21:24:33 -0500
X-MC-Unique: IxWloyvsN8uvF8KR1cvuTA-1
X-Mimecast-MFC-AGG-ID: IxWloyvsN8uvF8KR1cvuTA_1772504672
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3B3B1956059;
	Tue,  3 Mar 2026 02:24:31 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72E201800370;
	Tue,  3 Mar 2026 02:24:30 +0000 (UTC)
Date: Mon, 2 Mar 2026 21:24:28 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 11/13] livepatch/klp-build: add terminal color output
Message-ID: <aaZGXPbyH3QmrcQs@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-12-joe.lawrence@redhat.com>
 <7lykwpkqigzixza3xqhg7yqfhydcdim6dmzf2e5lembxjim6zb@z6y5n6qpb4xs>
 <oetssfso7zbcsleiapmqwfiwqcobu3ghsf26ubxbqnkild7dve@hpa3e45rgtp7>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oetssfso7zbcsleiapmqwfiwqcobu3ghsf26ubxbqnkild7dve@hpa3e45rgtp7>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: B695B1E7F9A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2101-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 01:32:09PM -0800, Josh Poimboeuf wrote:
> On Mon, Feb 23, 2026 at 01:28:45PM -0800, Josh Poimboeuf wrote:
> > On Tue, Feb 17, 2026 at 11:06:42AM -0500, Joe Lawrence wrote:
> > > Improve the readability of klp-build output by implementing a basic
> > > color scheme.  When the standard output and error are connected to a
> > > terminal, highlight status messages in bold, warnings in yellow, and
> > > errors in red.
> > > 
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > ---
> > >  scripts/livepatch/klp-build | 15 ++++++++++++---
> > >  1 file changed, 12 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > > index 80703ec4d775..fd104ace29e6 100755
> > > --- a/scripts/livepatch/klp-build
> > > +++ b/scripts/livepatch/klp-build
> > > @@ -52,6 +52,15 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
> > >  
> > >  KLP_DIFF_LOG="$DIFF_DIR/diff.log"
> > >  
> > > +# Terminal output colors
> > > +read -r COLOR_RESET COLOR_BOLD COLOR_ERROR COLOR_WARN <<< ""
> > > +if [[ -t 1 && -t 2 ]]; then
> > > +	COLOR_RESET="\033[0m"
> > > +	COLOR_BOLD="\033[1m"
> > > +	COLOR_ERROR="\033[0;31m"
> > > +	COLOR_WARN="\033[0;33m"
> > > +fi
> > > +
> > >  grep0() {
> > >  	# shellcheck disable=SC2317
> > >  	command grep "$@" || true
> > > @@ -65,15 +74,15 @@ grep() {
> > >  }
> > >  
> > >  status() {
> > > -	echo "$*"
> > > +	echo -e "${COLOR_BOLD}$*${COLOR_RESET}"
> > >  }
> > >  
> > >  warn() {
> > > -	echo "error: $SCRIPT: $*" >&2
> > > +	echo -e "${COLOR_WARN}warn${COLOR_RESET}: $SCRIPT: $*" >&2
> > 
> > Shouldn't this reset the colors *after* printing out the whole message?
> > 

Colorizing the "warn:" and "error:" was intended to look similar to gcc
color output.  I can easily highlight the entire message if you prefer.

> > Also, while it does make sense for warn() to print "warn:" rather than
> > "error:", note its called by trap_err(), which should print the latter.
> 
> also I think s/warn:/warning:/ is better.
> 

Ack to both for v4.

--
Joe


