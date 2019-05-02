Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558DE115B0
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfEBIqW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 04:46:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:35208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfEBIqV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 04:46:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 955F0AED4;
        Thu,  2 May 2019 08:46:20 +0000 (UTC)
Date:   Thu, 2 May 2019 10:46:20 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] livepatch: Fix kobject memleak
Message-ID: <20190502084620.vrtalu473z6wwo22@pathway.suse.cz>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-2-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502023142.20139-2-tobin@kernel.org>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-05-02 12:31:38, Tobin C. Harding wrote:
> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.

Strictly speaking there is no real memory leak in this case because
the structures are either static and or freed later via
klp_free*() functions.

That said, we could do the kobject manipulation a more clear way
as discussed in the 5th patch.

Anyway, thanks for cleaning this.

Best Regards,
Petr
