Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5DFC6C
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 17:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfD3PIO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 11:08:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:58536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbfD3PIN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 11:08:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2AA3DAD31;
        Tue, 30 Apr 2019 15:08:12 +0000 (UTC)
Date:   Tue, 30 Apr 2019 17:08:11 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] livepatch: Use correct kobject cleanup function
Message-ID: <20190430150811.4hzhtz4w46o6numh@pathway.suse.cz>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-3-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430001534.26246-3-tobin@kernel.org>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2019-04-30 10:15:34, Tobin C. Harding wrote:
> The correct cleanup function after a call to kobject_init_and_add() has
> succeeded is kobject_del() _not_ kobject_put().  kobject_del() calls
> kobject_put().

Really? I see only kobject_put(kobj->parent) in kobject_del.
It decreases a reference of the _parent_ object and not
the given one.

Also the section "Kobject removal" in Documentation/kobject.txt
says that kobject_del() is for two-stage removal. kobject_put()
still needs to get called at a later time.

IMHO, this patch causes that kobject_put() would never get called.

That said, we could probably make the removal a bit cleaner
by using kobject_del() in klp_free_patch_start() and
kobject_put() in klp_free_patch_finish(). But I have
to think more about it.

Best Regards,
Petr
