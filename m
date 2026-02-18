Return-Path: <live-patching+bounces-2045-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAToMUzYlWmmVQIAu9opvQ
	(envelope-from <live-patching+bounces-2045-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 16:18:36 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE7015758D
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 16:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8BE2030146A7
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 15:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E9333064C;
	Wed, 18 Feb 2026 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y13xR8T/"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04FF33BBC4
	for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771427911; cv=none; b=dEuARmIn4vICb2TGsA2uIrB1fIuwFRB5tPArWujhGuycYfIyEEIoR982EXlNCsVs95NJ1IxBuXgR5MV53zbc306muZ3+19E+RTb0umzUhAexca9EElNtwDq3CA+UpSv6npCgKwlOtGfNKE7ahiDRyoEQrvU1DPohcRfJmrwQaIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771427911; c=relaxed/simple;
	bh=BXcyrVR/FM8nPzhuNX7xXstI2yPgpJuQqp+me0+nDE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ejiu6oseVO70xPESkt9/Xb2ebdugzv9zxWY1ECEVUFdTfcMPuwvfuks09T5k41goYj71VqLbuwHVRXFfZ1cbV1yOcLNwzAIDFHJH7iss9LDrwmA5HU+RmYXgZbM8T0yzB0Tb1W3bWtcRb8if3U2/KL2k6XWPJIIOo2eWG957CI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y13xR8T/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771427908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fp2xrC9bKGNFLrida/fnPjkY6pS1rb4Hfl9xpx4Cr3k=;
	b=Y13xR8T/eUnH55ooAhQjuOXMcX7INZEdJWXjUBCgb23napIwu8zzX0DQ2Shn/Sa6ZNCc3M
	A+zPB/vAh4e4N40L1FtrdA7Qnc/7Viji6DJZ0aTGFCKXPvcC2iPyaRwMtAKlARUYQbLoYK
	YuiOBfj86MzEkDedVd8fD3GC7r2BkwA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-ik0U0Tr4M0m8Upoq-UHajg-1; Wed,
 18 Feb 2026 10:18:25 -0500
X-MC-Unique: ik0U0Tr4M0m8Upoq-UHajg-1
X-Mimecast-MFC-AGG-ID: ik0U0Tr4M0m8Upoq-UHajg_1771427904
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C0771956054;
	Wed, 18 Feb 2026 15:18:24 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B51D130001A5;
	Wed, 18 Feb 2026 15:18:22 +0000 (UTC)
Date: Wed, 18 Feb 2026 10:18:19 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 13/13] livepatch/klp-build: don't look for changed
 objects in tools/
Message-ID: <aZXYO5ZZPV72qOPD@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-14-joe.lawrence@redhat.com>
 <CAPhsuW6=9OUGdLBR1OhNDk2tbFncGfYe+z7HDr16si06g4AXGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6=9OUGdLBR1OhNDk2tbFncGfYe+z7HDr16si06g4AXGw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2045-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 6EE7015758D
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:29:13AM -0800, Song Liu wrote:
> On Tue, Feb 17, 2026 at 8:07 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> 
> I guess we still need a short commit message.
> 

Heh, checkpatch complained, but I didn't think such a trivial change
needed a full body :)

> Could you please share the patch that needs this change?
> 

Sorry I don't have a specific patch or repro for this one.  I hit this
during one of my -T, -T -S 2 short-circuiting testing runs.  I got an
error like this:

  error: klp-build: missing livepatch-cmdline-string.o for tools/testing/selftests/klp-build/artifacts/full-virtme-ng/cmdline-string/livepatch-cmdline-string.ko

to which I wondered why are we even looking for changed kernel objects
in tools/ ?  That directory may be stuffed with other weird stuff, a
combination of user-space and kernel-test .o's, so why bother? 

I can drop this one until it becomes something required.

--
Joe

> Thanks,
> Song
> 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  scripts/livepatch/klp-build | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index 5367d573b94b..9bbce09cfb74 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -564,8 +564,8 @@ find_objects() {
> >         local opts=("$@")
> >
> >         # Find root-level vmlinux.o and non-root-level .ko files,
> > -       # excluding klp-tmp/ and .git/
> > -       find "$OBJ" \( -path "$TMP_DIR" -o -path "$OBJ/.git" -o -regex "$OBJ/[^/][^/]*\.ko" \) -prune -o \
> > +       # excluding klp-tmp/, .git/, and tools/
> > +       find "$OBJ" \( -path "$TMP_DIR" -o -path "$OBJ/.git" -o -path "$OBJ/tools" -o -regex "$OBJ/[^/][^/]*\.ko" \) -prune -o \
> >                     -type f "${opts[@]}"                                \
> >                     \( -name "*.ko" -o -path "$OBJ/vmlinux.o" \)        \
> >                     -printf '%P\n'
> > --
> > 2.53.0
> >
> >
> 


