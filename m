Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C203492243
	for <lists+live-patching@lfdr.de>; Mon, 19 Aug 2019 13:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHSL0Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Aug 2019 07:26:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:40696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbfHSL0X (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Aug 2019 07:26:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E208AE40;
        Mon, 19 Aug 2019 11:26:22 +0000 (UTC)
Date:   Mon, 19 Aug 2019 13:26:21 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Nullify obj->mod in klp_module_coming()'s
 error path
Message-ID: <20190819112621.qtvmjofdmae33ruz@pathway.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-2-mbenes@suse.cz>
 <20190728194533.rghqjzwxyc2vwdvm@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728194533.rghqjzwxyc2vwdvm@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun 2019-07-28 14:45:33, Josh Poimboeuf wrote:
> On Fri, Jul 19, 2019 at 02:28:39PM +0200, Miroslav Benes wrote:
> > klp_module_coming() is called for every module appearing in the system.
> > It sets obj->mod to a patched module for klp_object obj. Unfortunately
> > it leaves it set even if an error happens later in the function and the
> > patched module is not allowed to be loaded.
> > 
> > klp_is_object_loaded() uses obj->mod variable and could currently give a
> > wrong return value. The bug is probably harmless as of now.
> > 
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

This patch has been committed into the branch for-5.4/core.

Best Regards,
Petr
