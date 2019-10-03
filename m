Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783D6C9A6A
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2019 11:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJCJJN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Oct 2019 05:09:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:52602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727357AbfJCJJN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Oct 2019 05:09:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFFDAB14B;
        Thu,  3 Oct 2019 09:09:11 +0000 (UTC)
Date:   Thu, 3 Oct 2019 11:08:47 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     jikos@kernel.org, jpoimboe@redhat.com, joe.lawrence@redhat.com,
        nstange@suse.de, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] livepatch: Clean up klp_update_object_relocations()
 return paths
In-Reply-To: <20191002134623.b6mwrvenrywgwdce@pathway.suse.cz>
Message-ID: <alpine.LSU.2.21.1910031100150.9011@pobox.suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz> <20190905124514.8944-4-mbenes@suse.cz> <20191002134623.b6mwrvenrywgwdce@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2 Oct 2019, Petr Mladek wrote:

> On Thu 2019-09-05 14:45:14, Miroslav Benes wrote:
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> 
> This might depend on personal preferences.

True.

> What was the motivation
> for this patch, please? Did it just follow some common
> style in this source file?

We had it like this once, so it is only going back to the original code. 
And yes, I think it is better.

Commit b56b36ee6751 ("livepatch: Cleanup module page permission changes") 
changed it due to the error handling. Commit 255e732c61db ("livepatch: use 
arch_klp_init_object_loaded() to finish arch-specific tasks") removed the 
reason for the change but did not cleanup the rest.

> To make it clear. I have no real preference. I just want to avoid
> some back and forth changes of the code depending on who touches
> it at the moment.

I have no real preference either. I noticed something I did not like while 
touching the code and that's it.

> I would prefer to either remove this patch or explain the motivation
> in the commit message. Beside that
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>

Ok, thanks.
Miroslav
