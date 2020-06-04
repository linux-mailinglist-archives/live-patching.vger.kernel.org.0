Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029911EE1C6
	for <lists+live-patching@lfdr.de>; Thu,  4 Jun 2020 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgFDJts (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Jun 2020 05:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbgFDJtr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Jun 2020 05:49:47 -0400
Received: from linux-8ccs.fritz.box (p57a23121.dip0.t-ipconnect.de [87.162.49.33])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD91E206C3;
        Thu,  4 Jun 2020 09:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591264187;
        bh=MSoPfCD32setc2DCvXKU3KrsCtKnZs3ZtbYkiynJsdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J2kq0P1U2CPSwhdf6nV7CGyGhL37w7q03AsTcECfhGcd8tMhCc642E9qKUmbHjqnz
         KcEPZJKWuxaw2P+39n1TSGHwbo4A3rMA1SgEpBJwcVXOQdWpvc3bKJaFdHfZRiHbmW
         e3Xay1sTJ0okbeWTmWKUsbxoOSuvhlZQbMntPeGs=
Date:   Thu, 4 Jun 2020 11:49:42 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Cheng Jian <cj.chengjian@huawei.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, chenwandun@huawei.com,
        xiexiuqi@huawei.com, bobo.shaobowang@huawei.com,
        huawei.libin@huawei.com, jikos@kernel.org
Subject: Re: [PATCH] module: make module symbols visible after init
Message-ID: <20200604094942.GA14963@linux-8ccs.fritz.box>
References: <20200603141200.17745-1-cj.chengjian@huawei.com>
 <alpine.LSU.2.21.2006031848020.26737@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2006031848020.26737@pobox.suse.cz>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Miroslav Benes [03/06/20 19:00 +0200]:
>> In commit 0bd476e6c671 ("kallsyms: unexport kallsyms_lookup_name() and
>> kallsyms_on_each_symbol()") restricts the invocation for kernel unexported
>> symbols, but it is still incorrect to make the symbols of non-LIVE modules
>> visible to the outside.
>
>Why? It could easily break something somewhere. I didn't check properly,
>but module states are not safe to play with, so I'd be conservative here.

Fully agree here. And it is not incorrect to make the symbols of
non-live modules visible via kallsyms. For one, kallsyms needs to
be able to see a module's symbols already even while in the COMING
state, because we can already oops/panic inside the module during
parse_args(), and symbol resolution via kallsyms is needed here even
though the module is not live. I have not checked carefully yet if
there are other users of kallsyms out there that might need to see
module symbols even when it is still coming, but for the first reason
alone I would not make this change.

Jessica
