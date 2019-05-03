Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B31133F4
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 21:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfECTQg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 15:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfECTQg (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 15:16:36 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78514206BB;
        Fri,  3 May 2019 19:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556910996;
        bh=GHcI7jy30ZlqmwJKk9SIWWZDOjhGvPfCm1ybawF8u2U=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ddqiTnXUJ29CIXlf6JMuYmrs/LVfE6vGNy8Wo6HVbBEaH4GZXIfBXpAeiZHL+dI5v
         ReDpLRQlB2Ksy4U51OnbvdunQUGnMcF6XjzpiIuCAujQg5m4cUOiNJgrYiKyPxWJAx
         s3P/4GLtKoDVCinVxKwXKAMtodjKG91uyR87B+sw=
Date:   Fri, 3 May 2019 21:16:32 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch: Remove custom kobject state handling and
 duplicated code
In-Reply-To: <20190503132625.23442-1-pmladek@suse.com>
Message-ID: <nycvar.YFH.7.76.1905032115490.10635@cbobk.fhfr.pm>
References: <20190503132625.23442-1-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 3 May 2019, Petr Mladek wrote:

> Tobin's patch[1] uncovered that the livepatching code handles kobjects
> a too complicated way.
> 
> The first patch removes the unnecessary custom kobject state handling.
> 
> The second patch is an optional code deduplication. I did something
> similar already when introducing the atomic replace. But it was
> not considered worth it. There are more duplicated things now...
> 
> [1] https://lkml.kernel.org/r/20190430001534.26246-1-tobin@kernel.org
> 
> 
> Petr Mladek (2):
>   livepatch: Remove custom kobject state handling
>   livepatch: Remove duplicated code for early initialization

I've applied this to for-5.2/core. Thanks,

-- 
Jiri Kosina
SUSE Labs

