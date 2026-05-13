Return-Path: <live-patching+bounces-2806-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BgKHc6pBGqRMgIAu9opvQ
	(envelope-from <live-patching+bounces-2806-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 18:41:50 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8936537462
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 18:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9EF731A7DF8
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EC748122E;
	Wed, 13 May 2026 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MH4OYFuO"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E153043D5
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688836; cv=none; b=eHCqAwxfb50LY+2GZ7YcjeSJrfrFXG+4r+5/4TWvVq3cyw/kvviwLHcbKP6JJ1QRPX4FpojbaIulLvR+zuszV2niVkmaJiVRCuRqPLg0Q06c8aFZmq12qhv7FO9ajsSq3OKR/7desH/OPNkFx+UQAiGy50G1mGZnNbOQV8VrFAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688836; c=relaxed/simple;
	bh=eionh5K6CX1qf0wZ2jbG0CMQ7IHTu+g9GIrexmtfgnI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZaOyZbf02PorxKJVblxqltb7HG8OHfLnfaXOH+MDBkRGOZJ36tGOBvnEPxmj1DLnzVBduXEavOjjjx9/jE9aVh3FHCPW1unu9tQTbkhQ7669QSEMA/xvwGHLimqvlbUSfM3U7tSmfEcdojS9WV8zlNkrfNe2uauFkJfWXaL1zM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MH4OYFuO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778688833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=nR7fWND0gDo6YiWVYGjJQiRZEY/GhckLUr7ee7vyN40=;
	b=MH4OYFuOtNW6mgtbrfPnWZ9tl5aA5jtGIDKxboHMLxjtuf63SBQxKITbwPFzu/c6i3VCBj
	pUWwoOwKN1PT4GcNqH83WVtIqWug8slCX3IRakaBW2GlJ6EcAPl4t5oG58pSzjcTXjIsz6
	7mH1KPNEamTJ2+T9ykfVMAtjVGSvwkg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-f-6np2BjOBWTL8Ss4ctRYw-1; Wed,
 13 May 2026 12:13:45 -0400
X-MC-Unique: f-6np2BjOBWTL8Ss4ctRYw-1
X-Mimecast-MFC-AGG-ID: f-6np2BjOBWTL8Ss4ctRYw_1778688822
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 658CD18002DD;
	Wed, 13 May 2026 16:13:42 +0000 (UTC)
Received: from redhat.com (unknown [10.22.89.145])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 483C61800349;
	Wed, 13 May 2026 16:13:41 +0000 (UTC)
Date: Wed, 13 May 2026 12:13:39 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>
Subject: Sashiko patch review for live-patching?
Message-ID: <agSjM8dxgnV9QQaf@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: B8936537462
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-2806-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sashiko.dev:url]
X-Rspamd-Action: no action

Hello live-patching maintainers,

I've noticed several references to the Sashiko (https://sashiko.dev/)
kernel review bot on this list and was wondering if there is interest in
adding live-patching to the mailing lists Sashiko tracks.

Integration appears straightforward: we can submit an MR to add our
entry to sashiko-k8s.yaml and customize the bot's email behavior in
email_policy.toml.

Full Sashiko Maintainer documentation is available here:
https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md

Personally, I would vote to set reply_to_author.  I don't have a strong
opinion on the other custom options, provided that the CC list is opt-in
rather than simply mirrored from the MAINTAINERS::LIVE PATCHING file.
Either way, I've found the Sashiko web interface very helpful in patch
review.

--
Joe


