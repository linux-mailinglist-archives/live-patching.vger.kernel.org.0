Return-Path: <live-patching+bounces-1932-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aC/JIbHxfGndPQIAu9opvQ
	(envelope-from <live-patching+bounces-1932-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:17 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 317F3BD8F8
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74AED300D444
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 18:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443E73148D0;
	Fri, 30 Jan 2026 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ozg9eb7z"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96E43101A5
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769796010; cv=none; b=X+0AHKm+WsBFnFIhZ40cvyVuh9KzXKNB4/t86+V0uvA3F6p1t4WYlP9HsA8AaB/q3PijS/8y1hhglv2vjJUJfwUALJfV2PPAJQrzSlbYzAl8F/hUPdXP+uIccsyGXiJE8iU0NYLLHVFNt51vUQcDwK0ttJVH5GQJtzzAVTgEYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769796010; c=relaxed/simple;
	bh=x5sQu826IT4TJ7n1UIYMq96ZjzBEoIIgpfxA38KOK1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aljanggKp1FViHwQXYcgZDCVZxjiP2olgdFTTqQeiBVqqXRjfHc1VynWGhowfocJzr4W57g2EwlHj9u/A4VpSmRo5M6osw7CAsRykEOLbtWb0rx0eocEOoalyfq2XzUOZsaGBQZ29z63ohTYwP6xHQnKAPM8vbCa0rKfYvjH0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ozg9eb7z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769796008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8MjBHiSvft8ABI85W6GRKOrOcT4LfgRm/0OKZraGDKg=;
	b=Ozg9eb7zbsT2yYxWvDvqRRZGZJHWMiYRTtYqakGnDlx2+15MfOA2T6kcya5htQJUbVo0m2
	RqGEk0HZypyv7gVhVkYPPKPk68to7QScfU6+LxudprI8oGgCJp5fID/mSrjObcLOKarSzR
	UNsOEnDw8jkJdF48mwS9lWwRieHNrjs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-XeKjEyKYO1eF3jIghArIpg-1; Fri,
 30 Jan 2026 13:00:01 -0500
X-MC-Unique: XeKjEyKYO1eF3jIghArIpg-1
X-Mimecast-MFC-AGG-ID: XeKjEyKYO1eF3jIghArIpg_1769796000
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A2411800447;
	Fri, 30 Jan 2026 18:00:00 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D4F5F1800665;
	Fri, 30 Jan 2026 17:59:58 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/5] objtool/klp-build: small fixups and enhancements
Date: Fri, 30 Jan 2026 12:59:45 -0500
Message-ID: <20260130175950.1056961-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1932-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 317F3BD8F8
X-Rspamd-Action: no action

Hi Josh,

While porting over some internal tests to use klp-build, I tripped over
a few small usability bugs and nits.  These are aren't show-stoppers,
but a few were pretty esoteric to debug and might lead some users down
similar rabbit holes.

Look for per-patch failure messages and reproducers in the individual
patch diffstat areas.  LMK if any of those details should make it into
the commit messages as I assumed they were only interesting for
reviewing context.

Finally these are very lightly tested, so any additional patches you'd
like to send through these changes would be welcome.

-- Joe


Joe Lawrence (5):
  objtool/klp: limit parent .git directory search
  objtool/klp: handle patches that add new files
  objtool/klp: validate patches with git apply --recount
  objtool/klp: add -z/--fuzz patch rebasing option
  objtool/klp: provide friendlier error messages

 scripts/livepatch/klp-build | 144 ++++++++++++++++++++++++++++++++----
 1 file changed, 130 insertions(+), 14 deletions(-)

-- 
2.52.0


