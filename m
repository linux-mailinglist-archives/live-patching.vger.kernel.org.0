Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5E941EC7
	for <lists+live-patching@lfdr.de>; Wed, 12 Jun 2019 10:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfFLIP2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Jun 2019 04:15:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:43438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbfFLIP2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Jun 2019 04:15:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C91FAF21;
        Wed, 12 Jun 2019 08:15:27 +0000 (UTC)
Date:   Wed, 12 Jun 2019 10:15:26 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        kamalesh@linux.vnet.ibm.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] Revert "livepatch: Remove reliable stacktrace
 check in klp_try_switch_task()"
Message-ID: <20190612081526.3d443z3lpw45vuhs@pathway.suse.cz>
References: <20190611141320.25359-1-mbenes@suse.cz>
 <20190611141320.25359-3-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611141320.25359-3-mbenes@suse.cz>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2019-06-11 16:13:19, Miroslav Benes wrote:
> This reverts commit 1d98a69e5cef3aeb68bcefab0e67e342d6bb4dad. Commit
> 31adf2308f33 ("livepatch: Convert error about unsupported reliable
> stacktrace into a warning") weakened the enforcement for architectures
> to have reliable stack traces support. The system only warns now about
> it.
> 
> It only makes sense to reintroduce the compile time checking in
> klp_try_switch_task() again and bail out early.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
