Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A997513154
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 17:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfECPjM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 11:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbfECPjM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 11:39:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 966AC3092649;
        Fri,  3 May 2019 15:39:12 +0000 (UTC)
Received: from redhat.com (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FDB35C8BC;
        Fri,  3 May 2019 15:39:11 +0000 (UTC)
Date:   Fri, 3 May 2019 11:39:09 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch: Remove custom kobject state handling and
 duplicated code
Message-ID: <20190503153909.GD24094@redhat.com>
References: <20190503132625.23442-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503132625.23442-1-pmladek@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 03 May 2019 15:39:12 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 03, 2019 at 03:26:23PM +0200, Petr Mladek wrote:
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
> 
>  include/linux/livepatch.h |  3 --
>  kernel/livepatch/core.c   | 86 ++++++++++++++++++++---------------------------
>  2 files changed, 37 insertions(+), 52 deletions(-)
> 
> -- 
> 2.16.4
> 

For the series,

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe
