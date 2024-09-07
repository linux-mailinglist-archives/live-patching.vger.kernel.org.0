Return-Path: <live-patching+bounces-630-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF159702A9
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 16:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3836B1F22429
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 14:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A05E1DFE4;
	Sat,  7 Sep 2024 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CNhzSMDV"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38721171C
	for <live-patching@vger.kernel.org>; Sat,  7 Sep 2024 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725718668; cv=none; b=YzSeehOYi+rGQlCdrMzcZBPIPWp3owe+k+WsjFtZhF4FaKNNeyhjG2yn941X//citAy4LoS4HhBjhB0NySVBQ20mOxeAL/eajiKwgX00TsMhcI+Ox4zJo19L834rPHk+V+cj9CYzTuNi2yA/HYLD2Zj4kzQwrA1PXpYlZVYlpO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725718668; c=relaxed/simple;
	bh=gJGUibqKAbC++DCYC9bNNkLDiSrL70WQmVVk67pP830=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZTc9aSTByK3OmPrMDdxROZh+uWqioJn77K4ffEtxpDqhFcZBN3WfvDHvQI1ULP2E90t3m1jIszyys2Pnf6uHQck+a/8Kjgy79tvqhZm11vJkNT4a4sCLABviC2H6LmW6rlj7zFBBDtSOuvykviBjVxEbGReQO9x+FD4xoEKjvr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CNhzSMDV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725718665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5kBE1l/JBjmXJiKdf5BwN+Xl9VjB2ieRInicxNpMmK0=;
	b=CNhzSMDViK1YvVNp0GCuzisVKkzqQBN4syt6pvdVYXeY7l6WwPTu2fUnV6CufAQ8YjOZz2
	12CYnITkBYIANTw6dA/BNPPAFO6Hqm3dJGEekp4cevSYUZq4zoIkyTMAOi6AaDbvMlVQdi
	2NcunXu0axIO501v1OnBy6W0G+Ewhho=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-iCRCNCHlNiaCs18-0uS33A-1; Sat,
 07 Sep 2024 10:17:42 -0400
X-MC-Unique: iCRCNCHlNiaCs18-0uS33A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4931119560A2;
	Sat,  7 Sep 2024 14:17:40 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.23])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEF141956086;
	Sat,  7 Sep 2024 14:17:37 +0000 (UTC)
Date: Sat, 7 Sep 2024 10:17:35 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <Ztxgf6RGHwlonpus@redhat.com>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZtsJ9qIPcADVce2i@redhat.com>
 <20240907014706.hw57colm6caxotyw@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240907014706.hw57colm6caxotyw@treble>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Sep 06, 2024 at 06:47:06PM -0700, Josh Poimboeuf wrote:
> 
> Normally I build objtool with
> 
>   make tools/objtool
> 
> or just
> 
>   make
> 
> Those use the objtool Makefile without all the extra kernel flags.
> 
> How do you normally build objtool?
>

Usually as part of the kernel build, for example:

  $ git clone \
      git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git \
      --branch klp-build-rfc

  $ cd linux && make -s defconfig && make -j$(nproc)

Results in the same implicit function declaration and uninitialized
variables errors.  (Thanks to tools/objtool/Makefile's OBJTOOL_CFLAGS :=
-Werror I believe.)

Re-reading my report, I thought building the two object files (check.o
and klp-diff.o) individually would report their respective problems, but
I see now that the invocation seems to want to build all the .o's, so
disregard that build wrinkle.  I almost always build objtool by a
top-level `make` or `make tools/objtool`, so sorry for any confusion.

--
Joe


