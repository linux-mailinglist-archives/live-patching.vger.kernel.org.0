Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29C51CCE90
	for <lists+live-patching@lfdr.de>; Mon, 11 May 2020 00:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgEJWcp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 10 May 2020 18:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgEJWco (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 10 May 2020 18:32:44 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD802071C;
        Sun, 10 May 2020 22:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589149964;
        bh=Yk3T1V9sIfrkBHrMZ2y69yZMO1JRC92XyxBLXdI20gQ=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=BL6gBEUShAG17Svt4bBbgvvFlZ/YUDTm/UjcSOuHFSYjizbIoD9FkowVO4rT5Z/7l
         l5Ne1+AMng8n3ZcvNqvKaNm/ZNoO9+7Iyo3DrApa3kCd+qf13dBgSPvkgDVvVaoMfT
         AuaysSraaimQxN41JSbavmogSDicShwkTNdP7EBU=
Date:   Mon, 11 May 2020 00:32:41 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Samuel Zou <zou_wei@huawei.com>
cc:     jpoimboe@redhat.com, mbenes@suse.cz, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] livepatch: Make klp_apply_object_relocs
 static
In-Reply-To: <1588987001-27863-1-git-send-email-zou_wei@huawei.com>
Message-ID: <nycvar.YFH.7.76.2005110032190.25812@cbobk.fhfr.pm>
References: <1588987001-27863-1-git-send-email-zou_wei@huawei.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, 9 May 2020, Samuel Zou wrote:

> Fix the following sparse warning:
> 
> kernel/livepatch/core.c:748:5: warning: symbol 'klp_apply_object_relocs' was not declared.
> 
> The klp_apply_object_relocs() has only one call site within core.c
> It should be static
> 
> Fixes: 7c8e2bdd5f0d ("livepatch: Apply vmlinux-specific KLP relocations early")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>

Merged in for-5.8/klp-module-fixups branch now. Thanks,

-- 
Jiri Kosina
SUSE Labs

