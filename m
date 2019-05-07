Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7964D163C6
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 14:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEGMc7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 08:32:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:55620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbfEGMc7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 08:32:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3E064AE14;
        Tue,  7 May 2019 12:32:58 +0000 (UTC)
Date:   Tue, 7 May 2019 14:32:57 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Remove custom kobject state handling
In-Reply-To: <20190503132625.23442-2-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1905071355430.7486@pobox.suse.cz>
References: <20190503132625.23442-1-pmladek@suse.com> <20190503132625.23442-2-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 3 May 2019, Petr Mladek wrote:

> kobject_init() always succeeds and sets the reference count to 1.
> It allows to always free the structures via kobject_put() and
> the related release callback.
> 
> Note that the custom kobject state handling was used only
> because we did not know that kobject_put() can and actually
> should get called even when kobject_init_and_add() fails.
> 
> The patch should not change the existing behavior.

Pity that the changelog does not describe the change from 
kobject_init_and_add() to two-stage kobject init (separate kobject_init() 
and kobject_add()).

Petr changed it, because now each member of new dynamic lists (created in 
klp_init_patch_early()) is initialized with kobject_init(), so we do not 
have to worry about calling kobject_put() (this is slightly different from 
kobj_added).

It would also be possible to retain kobject_init_and_add() and move it to 
klp_init_patch_early(), but it would be uglier in my opinion.

Miroslav
