Return-Path: <live-patching+bounces-1287-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD65EA6757C
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 14:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEFF93A78AA
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 13:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEE220D4E1;
	Tue, 18 Mar 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RECNqfza"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA48220D4ED
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742305506; cv=none; b=T4T+fcIoxoLul35UcsEpzntGJIvYm1MhnI5DN1FlLloSU0RT5eRYu8PWOmQnXCQJlT+bcNLO69g8WH0WhM/jP7LOc95iE2B3253MDwSxNlqVL1yQdIjIHp3AUvCYa7FVAz2r6wCl/BdoUZXBg4yF4/RoVJdWSnChOSdWYaF4qMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742305506; c=relaxed/simple;
	bh=z8ZhROhCdD/xwYUVT0yaiRqXps+1EicqfvvjgYBnoEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLEymod/gDgW5IZZWlKxaLxl/tgdL60t8q6qFDxb0y3DV1/0fUTlhLjLWCmxzYDnQ9AnBUxvdOVsFMm03t5R7BfFvBTylJRU6/lXNQr6guEU8p2NtR/AlDy40nZNtCVxopRAV8Jze5jZdo7fMpz5n1c0CPax3C7JVy/dh+U4djk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RECNqfza; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742305499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2lhcUqDKJV+KNebFeitMXNV1iwjt1Y6ND8x4B5XVx6Y=;
	b=RECNqfzaPR7jNxLFYxhjUQAMuV18VuEtzNiMyhthF/kDeYXZWHegBsHPieQkDHYw2YM6Eu
	lr9971uN3gOgUrnpf2ft04yNybpzuTd0ckNmqjEaWjvJ41B57qCB6Swp3jrI0RxZegk8tm
	pchuMlch0dI70h9HVELzq3EIIrIQgzo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-DCOsIRy6OS62zx5U3BrSOw-1; Tue,
 18 Mar 2025 09:44:50 -0400
X-MC-Unique: DCOsIRy6OS62zx5U3BrSOw-1
X-Mimecast-MFC-AGG-ID: DCOsIRy6OS62zx5U3BrSOw_1742305489
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD5D01955DD0;
	Tue, 18 Mar 2025 13:44:48 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.75])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C37FD3001D13;
	Tue, 18 Mar 2025 13:44:46 +0000 (UTC)
Date: Tue, 18 Mar 2025 09:44:44 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
	jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org,
	pmladek@suse.com
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
Message-ID: <Z9l4zJKzXHc51OMO@redhat.com>
References: <20250317165128.2356385-1-song@kernel.org>
 <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
 <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
 <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Mar 18, 2025 at 11:14:55AM +0100, Miroslav Benes wrote:
> Hi,
> 
> On Mon, 17 Mar 2025, Song Liu wrote:
> 
> > On Mon, Mar 17, 2025 at 11:59 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > >
> > > On 3/17/25 12:51, Song Liu wrote:
> > > > CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> > > > when CONFIG_KPROBES_ON_FTRACE is not set.
> > > >
> > > > Signed-off-by: Song Liu <song@kernel.org>
> > > > ---
> > > >  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > index 115065156016..fd823dd5dd7f 100755
> > > > --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > @@ -5,6 +5,8 @@
> > > >
> > > >  . $(dirname $0)/functions.sh
> > > >
> > > > +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
> > > > +
> > >
> > > Hi Song,
> > >
> > > This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (not
> > > set for RHEL distro kernels).
> > 
> > I was actually worrying about this when testing it.
> > 
> > > Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE support?
> > 
> > How about we grep kprobe_ftrace_ops from /proc/kallsyms?
> 
> which relies on having KALLSYMS_ALL enabled but since CONFIG_LIVEPATCH 
> depends on it, we are good. So I would say yes, it is a better option. 
> Please, add a comment around.
> 

Kallsyms is a good workaround as kprobe_ftrace_ops should be stable (I
hope :)

Since Song probably noticed this when upgrading and the new kprobes test
unexpectedly failed, I'd add a Fixes tag to help out backporters:

  Fixes: 62597edf6340 ("selftests: livepatch: test livepatching a kprobed function")

but IMHO not worth rushing as important through the merge window.


Also, while poking at this today with virtme-ng, my initial attempt had
build a fairly minimal kernel without CONFIG_DYNAMIC_DEBUG.  We can also
check for that via the sysfs interface to avoid confusing path-not-found
msgs, like the following ...

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

From c71f1966cfb7311bb1dde90c9f1be40704a253b6 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@redhat.com>
Date: Tue, 18 Mar 2025 09:26:55 -0400
Subject: [PATCH] selftests/livepatch: check for CONFIG_DYNAMIC_DEBUG
Content-type: text/plain

The livepatch kselftests set and restore dynamic debug to verify
subsystem behavior through expected printk messages.  The tests should
first check that this facility is available, otherwise just skip
running.

Fixes: a2818ee4dce5 ("selftests/livepatch: introduce tests")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/testing/selftests/livepatch/functions.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 15601402dee6..92bc083225a6 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -58,6 +58,9 @@ function die() {
 }
 
 function push_config() {
+	if [[ ! -e "$SYSFS_DEBUG_DIR/dynamic_debug" ]]; then
+		skip "test requires CONFIG_DYNAMIC_DEBUG"
+	fi
 	DYNAMIC_DEBUG=$(grep '^kernel/livepatch' "$SYSFS_DEBUG_DIR/dynamic_debug/control" | \
 			awk -F'[: ]' '{print "file " $1 " line " $2 " " $4}')
 	FTRACE_ENABLED=$(sysctl --values kernel.ftrace_enabled)
-- 
2.42.0


