Return-Path: <live-patching+bounces-2065-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COAcKP91nGmwHwQAu9opvQ
	(envelope-from <live-patching+bounces-2065-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 16:45:03 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AEC178F70
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 16:45:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5AA9B30A5B35
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 15:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4CC2ED84C;
	Mon, 23 Feb 2026 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hEz+CAPX"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8B62EDD6C
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771861175; cv=none; b=a7wteD4hD2RoKaPLexn9Kqi8Nqvo5AA3o0pkNcz989yh9W4lqwEsLM7QHas2sn6bdFpwP/sWgj9EUQBcv662CxDIYExHwpp/d9jYeTCdHqXYC54+/p7lB1W92YiO33g3jFmri4hJerHkRU4BFHM/An3Hl29Rr8SMrtCNheHzlJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771861175; c=relaxed/simple;
	bh=xHx2QtvuMMl81kLfh/pk5/YvM5YCK9SV6YTcKdH9I+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpve+4Np15jV+PWtajwNkdjqQpWSsZbxQF8E+P5jUsF7/he8DcxX+mBpvwEp4q1/V38rvcyZreOAR1853iVwTv5m4LjmvaL5JS5wWtntFu0gFQtS+agE2Ovmezn9JNO3p+Sz0U8h8tr84InQBNrjoCeAtNWTNybgR/oDu130TV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hEz+CAPX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771861173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I+qb2ND/P043jlrQlSxeHzqgiER2H6JlqtQO37r8Vuc=;
	b=hEz+CAPX7QzKhI3LCuMclSEp+Xb+Ly5IiJHEhsUxd9Y+sGTwUUJvocHJKgg/ObFIKfZ+nS
	NJNuFp/kmVI/Jb07Bi9X4j27bB1dH+JBxNnJIKy9Q5GUPSFr+SIhMDntfglF2kBINTtaWw
	4vENI85ekq+eVDK2ztPWqBhgT0MjSbQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-xLAfiAiJM2C0ypSdoTObxg-1; Mon,
 23 Feb 2026 10:39:28 -0500
X-MC-Unique: xLAfiAiJM2C0ypSdoTObxg-1
X-Mimecast-MFC-AGG-ID: xLAfiAiJM2C0ypSdoTObxg_1771861159
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D17E1800451;
	Mon, 23 Feb 2026 15:39:19 +0000 (UTC)
Received: from redhat.com (unknown [10.22.65.108])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B5F119560A2;
	Mon, 23 Feb 2026 15:39:17 +0000 (UTC)
Date: Mon, 23 Feb 2026 10:39:14 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests: livepatch: test-ftrace: livepatch a
 traced function
Message-ID: <aZx0ouPn_erDrFD4@redhat.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
 <20260220-lp-test-trace-v1-1-4b6703cd01a6@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-lp-test-trace-v1-1-4b6703cd01a6@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-2065-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 60AEC178F70
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 11:12:33AM -0300, Marcos Paulo de Souza wrote:
> This is basically the inverse case of commit 474eecc882ae
> ("selftests: livepatch: test if ftrace can trace a livepatched function")
> but ensuring that livepatch would work on a traced function.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/test-ftrace.sh | 36 ++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
> index 094176f1a46a..c6222cc037c5 100755
> --- a/tools/testing/selftests/livepatch/test-ftrace.sh
> +++ b/tools/testing/selftests/livepatch/test-ftrace.sh
> @@ -95,4 +95,40 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
>  livepatch: '$MOD_LIVEPATCH': unpatching complete
>  % rmmod $MOD_LIVEPATCH"
>  
> +
> +# - trace a function
> +# - verify livepatch can load targgeting no the same traced function

nitpick: s/targgeting no/targeting on/ ?

Otherwise LGTM,
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe


