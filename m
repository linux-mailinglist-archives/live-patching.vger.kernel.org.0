Return-Path: <live-patching+bounces-2102-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPbuCwpHpmlyNQAAu9opvQ
	(envelope-from <live-patching+bounces-2102-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:27:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C998B1E7FC8
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 38BF53016BAB
	for <lists+live-patching@lfdr.de>; Tue,  3 Mar 2026 02:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BDA73750BD;
	Tue,  3 Mar 2026 02:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QB+N0b8V"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E930C34A
	for <live-patching@vger.kernel.org>; Tue,  3 Mar 2026 02:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504839; cv=none; b=sxztlqZXNBBUegUlDF44WOXERP2A1aceOMmNgSBXz3FOHkYBCMOVBz9oNPk1FDvau++wr77jels/9q629taAS0zxyz7fDNgOTFpToM7HFs90Bd+POHmRUJI5IYW3rhVIkRcr/XJc35Q+aWWiOK9WB+p9e6SVYbN9tbnpfHQCNVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504839; c=relaxed/simple;
	bh=lk/VcCZV5SV+u9kADUyVA9yVApb6rNZhfpG5zS9b0UI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEiAvQC4Ccm8Y1aPqiOVb3NHLpIm84aijnMrzojQRopUcuAlPbq6h/y3rUO/qjyksRF8eflcSt7CkPW17fjL8fYVDjuThBt89y0E/Zs5eA9RHut3XZ5RhSkNdTsuwl7ixFSo9EZ2kQ+iYgWc8YxkcR16i2iQVvxE7CONSFbRYYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QB+N0b8V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772504836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/HP0zlwyCTlRzDx9T33MtYd6R5OwCE7bwuKMHRjphqE=;
	b=QB+N0b8VwLywQPzuCt46URlV4CqrqsPqA7QyoAuwhqT3LzkeXmPUDvbLP9mkNVqaQL2oCZ
	S9Gii3HpefrFP7OE+8Cr3ovV6kEh9z7fKeJvagMoPeX1DulR4rDXNS58nDai2gr6PnN3PH
	jeEeRDe8LlrvvvD8jxSpJ2TbWvTnBX4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-GSYJwJQvPJyyRl592cUaSQ-1; Mon,
 02 Mar 2026 21:27:13 -0500
X-MC-Unique: GSYJwJQvPJyyRl592cUaSQ-1
X-Mimecast-MFC-AGG-ID: GSYJwJQvPJyyRl592cUaSQ_1772504832
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E9A8195608D;
	Tue,  3 Mar 2026 02:27:12 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F3411956053;
	Tue,  3 Mar 2026 02:27:10 +0000 (UTC)
Date: Mon, 2 Mar 2026 21:27:08 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 12/13] livepatch/klp-build: report patch validation
 drift
Message-ID: <aaZG_BMmCj8MwDQd@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-13-joe.lawrence@redhat.com>
 <7iqwondhaweraszxu2xyjbz7lq6ttdd3yvg3erzuurboo757ov@4b5h7apjdarm>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7iqwondhaweraszxu2xyjbz7lq6ttdd3yvg3erzuurboo757ov@4b5h7apjdarm>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: C998B1E7FC8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2102-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 01:40:14PM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 17, 2026 at 11:06:43AM -0500, Joe Lawrence wrote:
> > Capture the output of the patch command to detect when a patch applies
> > with fuzz or line offsets.
> > 
> > If such "drift" is detected during the validation phase, warn the user
> > and display the details.  This helps identify input patches that may need
> > refreshing against the target source tree.
> > 
> > Ensure that internal patch operations (such as those in refresh_patch or
> > during the final build phase) can still run quietly.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  scripts/livepatch/klp-build | 24 +++++++++++++++++++-----
> >  1 file changed, 19 insertions(+), 5 deletions(-)
> > 
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index fd104ace29e6..5367d573b94b 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -369,11 +369,24 @@ check_unsupported_patches() {
> >  
> >  apply_patch() {
> >  	local patch="$1"
> > +	shift
> > +	local extra_args=("$@")
> > +	local drift_regex="with fuzz|offset [0-9]+ line"
> > +	local output
> > +	local status
> >  
> >  	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
> > -	patch -d "$SRC" -p1 --dry-run --silent --no-backup-if-mismatch -r /dev/null < "$patch"
> > -	patch -d "$SRC" -p1 --silent --no-backup-if-mismatch -r /dev/null < "$patch"
> > +	status=0
> > +	output=$(patch -d "$SRC" -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
> > +	if [[ "$status" -ne 0 ]]; then
> > +		echo "$output"
> > +		die "$patch did not apply"
> > +	elif [[ "$output" =~ $drift_regex ]]; then
> > +		warn "$patch applied with drift"
> > +		echo "$output"
> 
> Just for consistency with the output ordering of the "patch did not
> apply" error, I think the "$output" should be printed *before* the
> "$patch applied with drift".
> 
> Also, should $output be printed to stderr?
> 

Will adjust both ^^ for v4.

> Also, I've not heard of patch "drift", is "fuzz" better?
> 

Ah, I was trying to figure what word would include both offset and fuzz.
I /think/ "fuzz" may be used for both, so I can just use that for v4.

--
Joe


