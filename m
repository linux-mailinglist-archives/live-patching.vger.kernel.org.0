Return-Path: <live-patching+bounces-1320-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F03ACA6E1DD
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 18:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE72616A67E
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 17:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603A125F7B1;
	Mon, 24 Mar 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IXi63hB5"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D92627E9
	for <live-patching@vger.kernel.org>; Mon, 24 Mar 2025 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742839061; cv=none; b=jIp2+4dRdGIkHq1EPxQph5OBT5qWnDn+WIlinuO26aZUC90Q84jQKH7M6thzQquCTLr2mbYlvilNgYKLI4m96x/PTHc8PlXn1YqHSqmifZFC449GajD9FjJRf2MZmV9/xW8vr+EnBUCuamrysiUlQjMiZJbi0q1HV/mWd91zpzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742839061; c=relaxed/simple;
	bh=uKrhZa9TW3hgEjMb3gVsZ+f3LyjPZCZFiDmGQiKyRZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JF0ZQwH5zGj9bjPGUBmdHNcM5p0m5ORhoR2pMw+xdPjU45RI623m/qo7oZLBkRwWvJG8mB0lp8LOBHsxCBueRrT8NbWR8/o4p7X22aZHY1mvNTo0DIaigfn1REaxFlMVaQbYl5zRbf/7HBq4fiOAzgRsVPoqGxsLhTXpbULNrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IXi63hB5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742839058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E8407IqMrph474SSCXLwBIBGrVJHjy5HgFZdjY8ZpvE=;
	b=IXi63hB5roB4t9U98RXjipdLD89PpIs23R5LYzwvgrSQ1MuM9if5Hi/+rgFE0BYLZ+5wTj
	h+uKhKbThGXD3IZtoPgN+HVfG5aCnmnxoDE9GdZ/h9Q4C3s1I6nwS+4sMAMwUyuOSxM6s7
	QcOY9zmKsCeVxdNko8fM66B6/WalOCw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-QATyeUKdPBSWPYj8GZGfUQ-1; Mon,
 24 Mar 2025 13:57:36 -0400
X-MC-Unique: QATyeUKdPBSWPYj8GZGfUQ-1
X-Mimecast-MFC-AGG-ID: QATyeUKdPBSWPYj8GZGfUQ_1742839055
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A9DF196D2CF;
	Mon, 24 Mar 2025 17:57:35 +0000 (UTC)
Received: from redhat.com (unknown [10.22.81.75])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D53219560AB;
	Mon, 24 Mar 2025 17:57:33 +0000 (UTC)
Date: Mon, 24 Mar 2025 13:57:30 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org,
	kernel-team@meta.com, jikos@kernel.org, mbenes@suse.cz,
	pmladek@suse.com
Subject: Re: [PATCH v2] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
Message-ID: <Z+GdCmrrUjOWYqAo@redhat.com>
References: <20250318181518.1055532-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318181518.1055532-1-song@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Mar 18, 2025 at 11:15:18AM -0700, Song Liu wrote:
> CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> when CONFIG_KPROBES_ON_FTRACE is not set. Since some kernel may not have
> /proc/config.gz, grep for kprobe_ftrace_ops from /proc/kallsyms to check
> whether CONFIG_KPROBES_ON_FTRACE is enabled.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> 
> ---
> 
> Changes v1 => v2:
> 1. Grep for kprobe_ftrace_ops in /proc/kallsyms, as some systems may not
>    have /proc/config.gz
> ---
>  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
> index 115065156016..e514391c5454 100755
> --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> @@ -5,6 +5,8 @@
>  
>  . $(dirname $0)/functions.sh
>  
> +grep kprobe_ftrace_ops /proc/kallsyms || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
> +
>  MOD_LIVEPATCH=test_klp_livepatch
>  MOD_KPROBE=test_klp_kprobe
>  

Super minor nit (maybe Petr can tweak on merging): this grep (without
-q) will dump the resulting search lines to the terminal while all other
existing tests only show "TEST: description .... ok" lines they pass.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe


