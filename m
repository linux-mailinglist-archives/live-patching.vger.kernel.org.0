Return-Path: <live-patching+bounces-2044-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKZrOEzWlWlLVQIAu9opvQ
	(envelope-from <live-patching+bounces-2044-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 16:10:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A34B1574E4
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 16:10:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84E0A300C809
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 15:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540A72FBE05;
	Wed, 18 Feb 2026 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzL0hpeI"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C712285CB3
	for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771427359; cv=none; b=FoxEsDzx19hrgonVK0meQ972ys7F/1IIC5YTlpkGYMIr64hqniQmHfxzp997kRv/BDLH/KHlG3uagMOe5h1gN6kPO/GDr8m+VWtVLZeWdaq57lBSJo4kXWHqdvZpV4FSQrLa7LwCyq3KS4s8HkqW58KVAOfaBiyX5bLMwxSRlEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771427359; c=relaxed/simple;
	bh=P5Jx/xEj9y6KqzLfhjn+8+rJJ3BAoE6lVWLpnY7/bCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loDO+C4zWPM6tHBYmRRBEUjSt95ppIcLAmfw01fZLs95jar7d32EXvgtxPJJAEyTIYeLL0w2wcY/T5WfrY2ulWb8q7jVLtf/rAp/+HIbvuVMYaM7HdB3CkO0t9r45WNNg/iao5G5JEN8aP2tX/RbGB6HcRJi2xgcgZun0SMOvcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RzL0hpeI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771427357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYGeQrJjaG1tGLMjmIVL+2tHnG+PdGy9eLnVQsDM6Lw=;
	b=RzL0hpeIp/lBSzhsP+xcyf16ZM3S2Y1HLtWpwOWBKZellnkkSEZ/AfxQ019LeOwbeVT3Ef
	kzCAr687/CsShXNaeYZ9PC1m9e3OnZWLwBw1eYzGOONLQdePzla+/h1c0RIIA9kWwMMcfi
	UC+Dj/Xb70nU5BF2hBs3fiEt0sXmsoo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-ncOE2zNrMIKAU6L_tUOK0w-1; Wed,
 18 Feb 2026 10:09:15 -0500
X-MC-Unique: ncOE2zNrMIKAU6L_tUOK0w-1
X-Mimecast-MFC-AGG-ID: ncOE2zNrMIKAU6L_tUOK0w_1771427354
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 452DC193448A;
	Wed, 18 Feb 2026 15:09:14 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4C991800296;
	Wed, 18 Feb 2026 15:09:12 +0000 (UTC)
Date: Wed, 18 Feb 2026 10:09:10 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 12/13] livepatch/klp-build: report patch validation
 drift
Message-ID: <aZXWFrrTDC0HpEBT@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-13-joe.lawrence@redhat.com>
 <CAPhsuW4YN5PYp3iF8P3pBGF8vP62m0L-yEfD1pBut6fL+78N2Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4YN5PYp3iF8P3pBGF8vP62m0L-yEfD1pBut6fL+78N2Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2044-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6A34B1574E4
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:42:21AM -0800, Song Liu wrote:
> On Tue, Feb 17, 2026 at 8:07 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
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
> >         local patch="$1"
> > +       shift
> > +       local extra_args=("$@")
> > +       local drift_regex="with fuzz|offset [0-9]+ line"
> > +       local output
> > +       local status
> >
> >         [[ ! -f "$patch" ]] && die "$patch doesn't exist"
> > -       patch -d "$SRC" -p1 --dry-run --silent --no-backup-if-mismatch -r /dev/null < "$patch"
> > -       patch -d "$SRC" -p1 --silent --no-backup-if-mismatch -r /dev/null < "$patch"
> > +       status=0
> > +       output=$(patch -d "$SRC" -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
> > +       if [[ "$status" -ne 0 ]]; then
> > +               echo "$output"
> > +               die "$patch did not apply"
> > +       elif [[ "$output" =~ $drift_regex ]]; then
> > +               warn "$patch applied with drift"
> > +               echo "$output"
> > +       fi
> 
> It appears we only need the non-silent "patch" command and the reporting
> logic in validate_patches(). Maybe we can have a different version of
> apply_patches for validate_patches(), say apply_patches_verbose(), and
> keep existing apply_patch() and apply_patches as-is?
> 

Yes, you're right about the reporting cases.  Splitting might be
cleaner, I'll consider for v4.  This logic does get a little hairy to
handle the two cases of when we want to see output vs. not.  (set -o
errexit forces us to disarm anything that might throw an error and bring
down the whole show.) 

--
Joe


