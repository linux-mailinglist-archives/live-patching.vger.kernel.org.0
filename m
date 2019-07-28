Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30427814F
	for <lists+live-patching@lfdr.de>; Sun, 28 Jul 2019 21:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfG1Tpj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 28 Jul 2019 15:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfG1Tpj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 28 Jul 2019 15:45:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41F22C057E9F;
        Sun, 28 Jul 2019 19:45:39 +0000 (UTC)
Received: from treble (ovpn-120-102.rdu2.redhat.com [10.10.120.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2628060600;
        Sun, 28 Jul 2019 19:45:35 +0000 (UTC)
Date:   Sun, 28 Jul 2019 14:45:33 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Nullify obj->mod in klp_module_coming()'s
 error path
Message-ID: <20190728194533.rghqjzwxyc2vwdvm@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-2-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190719122840.15353-2-mbenes@suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sun, 28 Jul 2019 19:45:39 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 19, 2019 at 02:28:39PM +0200, Miroslav Benes wrote:
> klp_module_coming() is called for every module appearing in the system.
> It sets obj->mod to a patched module for klp_object obj. Unfortunately
> it leaves it set even if an error happens later in the function and the
> patched module is not allowed to be loaded.
> 
> klp_is_object_loaded() uses obj->mod variable and could currently give a
> wrong return value. The bug is probably harmless as of now.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Reviewed-by: Petr Mladek <pmladek@suse.com>

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
